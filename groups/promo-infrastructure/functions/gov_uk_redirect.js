async function handler(event) {
    const request = event.request;

    const gov_uk_prefix = 'https://gov.uk';
    const filing_uri_prefix = '/arefiling/';
    const freedom_of_information_uri_prefix = '/freedominformation/freedominfo.shtml';
    const press_desk_uri_prefix = '/pressDesk/introduction.shtml';

    let uri = request.uri;

    if (uri.startsWith(filing_uri_prefix)) {
        uri = uri.replace(filing_uri_prefix, '/file-your-confirmation-statement-with-companies-house/');
    } else if (uri.startsWith(freedom_of_information_uri_prefix)) {
        uri = uri.replace(freedom_of_information_uri_prefix, '/government/organisations/companies-house/about/personal-information-charter/');
    } else if (uri.startsWith(press_desk_uri_prefix)) {
        uri = uri.replace(press_desk_uri_prefix, '/government/organisations/companies-house/about/media-enquiries/');
    } else if (uri.endsWith('/')) {
        // Append default index file name to request
        request.uri += 'index.shtml';
        return request;
    } else {
        // Proceed with request; do not generate a redirect
        return request;
    }

    const response = {
        statusCode: 301,
        statusDescription: 'Moved Permanently',
        headers: {
            'location': { 'value': gov_uk_prefix + uri }
        }
    }

    return response;
}
