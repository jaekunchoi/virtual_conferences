module ApplicationHelper
  include ActionView::Helpers::AssetTagHelper

  def tooltip(title, placement = :bottom, html_options={})
    case placement
    when :top,:bottom,:left,:right
    else
      placement = :bottom
    end
    {"data-placement" => placement.to_s, "data-toggle" => "tooltip", "title" => title}.merge(html_options)
  end
  
  def clensedText(text)
    if text.nil?
      ""
    else
      text.gsub("<","&lt;").gsub(">","&gt;").gsub("\n","<br/>")
    end
  end
  
  def filter_contents(contents, contentTypeArr)
    contents.select {|content| contentTypeArr.include? (content.content_type) and content.valid_content?}
  end
  
  #Forces a line break within html with a given line size, spaces are used to break and an ellipsis is added. If
  # the string is one long piece of text, it will put in a dash at the line break. 
  def forceLineBreaksOnHtml(messageArray, maximumLineSize)
    finalArr = []
    messageArray.each do |messageLine|
      lineCharIndex = 0
      lineStartFrom = 0
      lineInHtml = false
      lineLastCharIsSpace = false
      lineLastSpaceIndex = 0
      
      messageLine.chars.each_with_index do |char, index|
        if (char == "<")
          lineInHtml = true
        end
        
        isCharASpace = (char =~ /\s/) != nil
        
        if lineInHtml
        elsif (isCharASpace && !lineLastCharIsSpace)
          lineLastCharIsSpace = true
          lineLastSpaceIndex = index
          lineCharIndex += 1
        elsif (!isCharASpace)
          lineCharIndex += 1
        end
        lineLastCharIsSpace = isCharASpace if !lineInHtml
        
        lineInHtml = false if (char == ">")
        
        if (lineCharIndex > maximumLineSize)
          if (lineLastSpaceIndex > lineStartFrom)
            puts "debug: index"+index.to_s+"lineCharIndex:"+lineCharIndex.to_s+" lineStartFrom:"+lineStartFrom.to_s+" lineInHtml:"+lineInHtml.to_s+ " lineLastCharIsSpace:"+lineLastCharIsSpace.to_s+ " lineLastSpaceIndex:"+lineLastSpaceIndex.to_s
            finalArr.push(messageLine[lineStartFrom..lineLastSpaceIndex-1] + "...")
            lineStartFrom = lineLastSpaceIndex
            lineCharIndex = 0
            puts "debug2: index"+index.to_s+"lineCharIndex:"+lineCharIndex.to_s+" lineStartFrom:"+lineStartFrom.to_s+" lineInHtml:"+lineInHtml.to_s+ " lineLastCharIsSpace:"+lineLastCharIsSpace.to_s+ " lineLastSpaceIndex:"+lineLastSpaceIndex.to_s
          else
            # this is a forced break in the middle of text
            finalArr.push(messageLine[lineStartFrom..index] + "-"+lineLastSpaceIndex.to_s+lineStartFrom.to_s)
            lineCharIndex = 0
            lineStartFrom = lineLastSpace = index
          end
          lineLastValidChar = ""
        end
        
        if index+1 == messageLine.size
          finalArr.push(messageLine[lineStartFrom..index])
        end
      end
    end
    
    finalArr
  end
  
  def get_booth_email(booth)
    if booth.email.present?
      booth.email
    elsif !booth.user.nil? && booth.user.email.present?
      booth.user.email
    else
      Rails.configuration.virtual_conferences.admin_email
    end
  end

  def get_event_id()
    event = get_event
    return nil unless event
    event.id
  end
  
  def get_event()
    host = request.host
    host = host.sub("www.","").partition(/\./)[0]
    Event.where("event_url like '%"+host+"%'").first
  end
  
  def sidebar_menu_item(top_menu_args, data_target, sub_menu_args, expanded, icon = "angle-left")
    haml_tag :li, :class => "#{'active' if expanded}" do
      haml_tag:a, :href => "#", :class => "accordion-toggle", "data-present" => "#menu", "data-toggle" => "collapse", "data-target" => "##{data_target}" do
        haml_concat "<i class='fa fa-#{top_menu_args[1]}'></i> #{top_menu_args[0]}"
        haml_tag :span, :class => "pull-right" do
          haml_tag :i, :class => "fa fa-angle-left"
        end
      end

      haml_tag :ul, :class => expanded == true ? 'collapse in' : 'collapse', :id => data_target do
        sub_menu_args.each do |menu_args|
          link = menu_args[0]
          label = menu_args[1]
          action = "/#{params[:action]}" if params[:action] != "index"
          current_uri = "/#{params[:controller]}#{action}"
          if link == current_uri
            active = { :class => "active" } 
          end
          haml_tag :li, active do
            haml_tag :a, :href => link do
              haml_concat "<i class='fa fa-angle-right'></i> #{label}"
            end
          end
        end
      end
    end
  end

  def box(columns = 6, title = nil, links = nil, colour = 'dark', class_name = '', footer = nil)
    haml_tag :div, :class => "col-lg-#{columns} #{class_name}", :id => title.downcase.gsub(" ", "") do
      haml_tag :div, :class => "box #{colour}" do
        haml_tag :header do
          haml_tag :div, :class => 'icons' do
            haml_tag :i, :class => 'fa fa-edit'
          end
          haml_tag :h5, :class => "tk-ff-meta-web-pro" do
            haml_concat title
          end
          if !links.nil?
            haml_tag :div, :class => 'toolbar' do
              haml_tag :ul, :class => 'nav' do
                links.each do |name, link|
                  haml_tag :li do
                    haml_concat "<a href='#{link}'>#{name}</a>"
                  end
                end
              end
            end
          end
        end
        haml_tag :div, :class => 'body' do
          yield
        end
        haml_tag :div, :class => 'footer' do
          haml_concat footer
        end
      end
    end
  end

  def paperclip_present?(image)
    image.present? && image.assets.present?
  end
  
  def paperclip_image_tag(image, options = nil)
    if image
      image_tag image.assets.url, options
    else
      noImage = options[:noImage] if options
      noImage ||= "missing.png"
      image_tag asset_path(noImage), options
    end
  end
  
  def simple_form_image_paperclip(form_object, field_name, options = nil)
    label = options[:label] if options
    
    label = form_object.label(field_name) if label.nil?
    
    image = eval("form_object.object."+field_name.to_s)
    
    image_url = (image ? image.assets.url : asset_path("missing.png"))
    image_url = asset_path("missing.png") if (image_url == "/assets/original/missing.png")
  
    form_object.fields_for field_name do |field|
      haml_concat field.label :assets, label, :class => 'col-lg-4 control-label'
      haml_tag :div, :class => 'col-lg-8' do
        haml_tag :div, :class => 'fileinput fileinput-new', "data-provides" => "fileinput" do
          haml_tag :div, :class => 'fileinput-preview thumbnail', "data-trigger" => "fileinput", "style" => "width:200px; height:150px;" do
            haml_tag :img, :src => image_url
          end
          haml_tag :div do
            haml_tag :span, :class => 'btn btn-default btn-file' do
              haml_tag :span, :class => 'fileinput-new' do
                haml_concat "Select image"
              end
              haml_tag :span, :class => 'fileinput-exists' do
                haml_concat "Change"
              end
              haml_concat field.file_field :assets
            end
            onclickmethod = "$('#"+field.lookup_model_names.join("_")+"_attributes_id').val('');"
            haml_tag :a, :class => 'btn btn-default'+ (image.present? and image.assets.present? ? '' : ' fileinput-exists'), :href => "#", "data-dismiss" => "fileinput", onclick: onclickmethod do
              haml_concat "Remove"
              
              #<input id="tag_thumbnail_image_attributes_id" name="tag[thumbnail_image_attributes][id]" type="hidden" value="344">
            end
          end
        end
      end
    end
  end

  #Only used for Sponsors
  def simple_form_image_paperclip_self(label, form_object, field_name, image_url)
    haml_concat form_object.label field_name, label, :class => 'col-lg-4 control-label'
    haml_tag :div, :class => 'col-lg-8' do
      haml_tag :div, :class => 'fileinput fileinput-new', "data-provides" => "fileinput" do
        haml_tag :div, :class => 'fileinput-preview thumbnail', "data-trigger" => "fileinput", "style" => "width:200px; height:150px;" do
          haml_tag :img, :src => image_url
        end
        haml_tag :div do
          haml_tag :span, :class => 'btn btn-default btn-file' do
            haml_tag :span, :class => 'fileinput-new' do
              haml_concat "Select image"
            end
            haml_tag :span, :class => 'fileinput-exists' do
              haml_concat "Change"
            end
            haml_concat form_object.file_field field_name
          end
          haml_tag :a, :class => 'btn btn-default fileinput-exists', :href => "#", "data-dismiss" => "fileinput" do
            haml_concat "Remove"
          end
        end
      end
    end
  end
  
  def form_input_current_user_id_preselection(f)
    f.association :user if current_user.has_role?(:vender) && current_user.has_role?(:admin)
      f.hidden_field :user_id, :value => current_user.id if current_user.has_role?(:booth_rep)
  end

  def embed_slideshare(url)
    @hash = JSON.parse "http://www.slideshare.net/api/oembed/2?format=json&url=#{url}"
  end
  
  alias_method :baseImageTag, :image_tag
  def image_tag(image, options = nil)
    image = "missing.png" if (image == "/assets/original/missing.png")
    if (options)
      baseImageTag(image, options)
    else
      baseImageTag(image)
    end
  end
  
  def boolean_YN(boolean)
    boolean ? "Yes" : "No"
  end

end
