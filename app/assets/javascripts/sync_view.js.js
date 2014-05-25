// Generated by CoffeeScript 1.6.3
var _ref, _ref1,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Sync.ChatChatWidget = (function(_super) {
  __extends(ChatChatWidget, _super);

  function ChatChatWidget() {
    _ref = ChatChatWidget.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  ChatChatWidget.prototype.beforeInsert = function($el) {
    $el.hide();
    return this.insert($el);
  };

  ChatChatWidget.prototype.afterInsert = function() {
    this.$el.addClass('animated bounceInLeft');
    return this.$el.fadeIn('fast');
  };

  ChatChatWidget.prototype.beforeRemove = function() {
    var _this = this;
    return this.$el.fadeOut('slow', function() {
      return _this.remove();
    });
  };

  return ChatChatWidget;

})(Sync.View);

Sync.ModeratedChatChatQnaWidget = (function(_super) {
  __extends(ModeratedChatChatQnaWidget, _super);

  function ModeratedChatChatQnaWidget() {
    _ref1 = ModeratedChatChatQnaWidget.__super__.constructor.apply(this, arguments);
    return _ref1;
  }

  ModeratedChatChatQnaWidget.prototype.beforeInsert = function($el) {
    $el.hide();
    return this.insert($el);
  };

  ModeratedChatChatQnaWidget.prototype.afterInsert = function() {
    this.$el.addClass('animated bounceInLeft');
    return this.$el.fadeIn('fast');
  };

  ModeratedChatChatQnaWidget.prototype.beforeUpdate = function(html, data) {
    return this.update(html);
  };

  ModeratedChatChatQnaWidget.prototype.beforeRemove = function() {
    var _this = this;
    return this.$el.fadeOut('slow', function() {
      return _this.remove();
    });
  };

  return ModeratedChatChatQnaWidget;

})(Sync.View);
