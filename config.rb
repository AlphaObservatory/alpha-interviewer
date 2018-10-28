page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :url_root, ENV.fetch('BASE_URL')

ignore '/templates/*'

activate :i18n, langs: [:en, :it, :es, :fr, :zh], mount_at_root: false
activate :asset_hash
activate :directory_indexes
activate :pagination
activate :inline_svg
activate :dato, token: ENV.fetch('DATO_API_TOKEN'), live_reload: false

activate :external_pipeline,
  name: :webpack,
  command: build? ?
    "./node_modules/webpack/bin/webpack.js --bail -p" :
    "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
  source: ".tmp/dist",
  latency: 1

configure :build do
  activate :minify_html do |html|
    html.remove_input_attributes = false
  end
  activate :search_engine_sitemap,
    default_priority: 0.5,
    default_change_frequency: 'weekly'
end

configure :development do
  activate :livereload
end

helpers do
  def active_link_to(name, url, options = {})
    if (url === "/#{I18n.locale}/" && current_page.url === "/#{I18n.locale}/") ||
      (url != "/#{I18n.locale}/" && current_page.url[0...-1].eql?(url))
      options[:class] = options.fetch(:class, '') + " is-active"
      link_to name, url, options
    else
      link_to name, url, options
    end
  end

  # attributes = {class: "", id: "", data: {role: {}, title: {}}}

  def icon(name, attributes={})
    default_attributes = {role: "icon"}
    default_attributes.merge!(attributes.except(:role))
    unless attributes.has_key? :class
      default_attributes[:class] ||= "icon-svg--#{name}"
    else
      default_attributes[:class] += " icon-svg--#{name}"
    end

    content_tag(:svg, default_attributes) do
      content_tag(:use, "", "xlink:href" => "##{name}")
    end
  end
  alias i icon
end

proxy "/_redirects", "/templates/redirects.txt"

dato.tap do |dato|
  [:en, :it, :es, :fr, :zh].each do |locale|
    I18n.with_locale(locale) do
      dato.steps.each do |step|
        I18n.locale = locale
        proxy "/#{locale}/#{step.codename}/index.html", "/templates/step.html", :locals => { step: step }, ignore: true, locale: locale
      end
    end
  end
end

#   [:en, :it].each do |locale|
#     I18n.with_locale(locale) do
#       I18n.locale = locale
#       paginate dato.articles.select{|a| a.published == true}.sort_by(&:date).reverse, "/#{I18n.locale}/articles", "/templates/articles.html", locals: { locale: I18n.locale }
#     end
#   end
# end
