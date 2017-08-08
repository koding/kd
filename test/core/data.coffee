should = require 'should'
sinon = require 'sinon'
shouldSinon = require 'should-sinon'
KDData = require '../../lib/core/data'
KDView = require '../../lib/core/view'


describe 'KDData', ->

  it 'exists', ->
    KDData.should.exist


  describe 'constructor', ->

    beforeEach ->
      unless KDData.isSupported()
        console.warn "KDData tests skipped since it's not supported on this platform"
        return this.skip()
      @instance = new KDData

    it 'should create emitter', ->
      KDData.getEmitter(@instance).should.exist


  describe 'data types', ->

    describe 'Objects', ->

      beforeEach ->

        return this.skip()  unless KDData.isSupported()
        @instance = new KDData {}

      it 'should support Object type', ->

        @instance.foo = 'bar'
        @instance.foo.should.equal 'bar'

      it 'should emit update changed fields on data change', ->

        emitter = KDData.getEmitter @instance
        emitter.should.exist

        spy = sinon.spy -> yes
        emitter.on 'update', spy

        @instance.foo = 'bar'
        spy.should.be.calledOnce()
        spy.should.be.calledWith ['foo']

        @instance.foo = 'baz'
        spy.should.be.calledTwice()
        spy.should.be.calledWith ['foo']

      it 'should support any level of depth', ->

        emitter = KDData.getEmitter @instance
        emitter.should.exist

        spy = sinon.spy -> yes
        emitter.on 'update', spy

        @instance.foo = { bar: { baz: 5 } }
        spy.should.be.calledOnce()
        spy.should.be.calledWith ['foo']

        @instance.foo.bar.baz += 10
        spy.should.be.calledTwice()
        spy.should.be.calledWith ['foo.bar.baz']

        @instance.foo.bar.baz.should.equal 15


    describe 'Arrays', ->

      beforeEach ->

        return this.skip()  unless KDData.isSupported()
        @instance = new KDData []

      it 'should support Array type', ->

        @instance.push 'bar'
        @instance[0].should.equal 'bar'


      it 'should emit update changed fields on data change', ->

        emitter = KDData.getEmitter @instance
        emitter.should.exist

        spy = sinon.spy -> yes
        emitter.on 'update', spy

        @instance.push 'bar'

        spy.should.be.calledTwice()
        spy.should.be.calledWith ['0'] # since first item changed
        spy.should.be.calledWith ['length'] # since a new item pushed

        @instance[0] = 'baz'
        spy.should.be.calledThrice()
        spy.should.be.calledWith ['0'] # since only first item changed


      it 'should support any level of depth', ->

        emitter = KDData.getEmitter @instance
        emitter.should.exist

        spy = sinon.spy -> yes
        emitter.on 'update', spy

        @instance[0] = ['foo', [1, 2]]
        spy.should.be.calledTwice()
        spy.should.be.calledWith ['0']
        spy.should.be.calledWith ['length']

        @instance[0][1][0] += 4
        spy.should.be.calledThrice()
        spy.should.be.calledWith ['0.1.0']
        @instance[0][1][0].should.be.equal 5

        @instance[0][1].push 10
        spy.should.be.calledWith ['0.1.length']

        @instance[0][1][2].should.be.equal 10


  describe 'triggers render on pistachio', ->

    describe 'with Objects', ->

      beforeEach ->

        return this.skip()  unless KDData.isSupported()
        @instance = new KDData { foo: 'bar', baz: 100 }

        @view = new KDView
          pistachio: "{{#(foo)}} - {{#(baz)}}"
        , @instance

        @view.viewAppended()

      afterEach ->
        @view.destroy()

      it 'should provide correct data for view', ->

        @view.getElement().innerHTML.should.equal '
          <span data-paths="foo" id="el-0">bar</span> -
          <span data-paths="baz" id="el-1">100</span>
        '

      it 'should render automatically on data change', ->

        @instance.foo = 'baz'
        @instance.baz += 10
        @view.getElement().innerHTML.should.equal '
          <span data-paths="foo" id="el-2">baz</span> -
          <span data-paths="baz" id="el-3">110</span>
        '

      it 'should only update changed fields', ->

        @instance.baz -= 10
        @view.getElement().innerHTML.should.equal '
          <span data-paths="foo" id="el-4">bar</span> -
          <span data-paths="baz" id="el-5">90</span>
        '

    describe 'with Arrays', ->

      beforeEach ->

        return this.skip()  unless KDData.isSupported()
        @instance = new KDData ['foo', 100]

        @view = new KDView
          pistachio: "{{#(0)}} - {{#(1)}} - {{#(length)}}"
        , @instance

        @view.viewAppended()

      afterEach ->
        @view.destroy()

      it 'should provide correct data for view', ->

        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-6">foo</span> -
          <span data-paths="1" id="el-7">100</span> -
          <span data-paths="length" id="el-8">2</span>
        '

      it 'should render automatically on data change', ->

        @instance[0] = 'baz'
        @instance[1] += 10
        @instance.push('test')
        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-9">baz</span> -
          <span data-paths="1" id="el-10">110</span> -
          <span data-paths="length" id="el-11">3</span>
        '

      it 'should only update changed fields', ->

        @instance[1] -= 10
        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-12">foo</span> -
          <span data-paths="1" id="el-13">90</span> -
          <span data-paths="length" id="el-14">2</span>
        '

      it 'should update Array length when needed', ->

        @instance.push 10
        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-15">foo</span> -
          <span data-paths="1" id="el-16">100</span> -
          <span data-paths="length" id="el-17">3</span>
        '

        @instance[5] = '6th element'
        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-15">foo</span> -
          <span data-paths="1" id="el-16">100</span> -
          <span data-paths="length" id="el-17">6</span>
        '

        @instance.pop()
        @view.getElement().innerHTML.should.equal '
          <span data-paths="0" id="el-15">foo</span> -
          <span data-paths="1" id="el-16">100</span> -
          <span data-paths="length" id="el-17">5</span>
        '
