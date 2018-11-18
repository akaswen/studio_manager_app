function myFetch(path, method) {
  let metaTag = document.querySelector('meta[name="csrf-token"]');
  let token = metaTag.getAttribute('content');

  return fetch(path, {
    method: method, 
    headers: {
      'X-CSRF-TOKEN': token
    },
  });
}
