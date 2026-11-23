const app = require('./app');

test('GET / returns KT3 App', () => {
  const res = { writeHead: jest.fn(), end: jest.fn() };
  app({ method: 'GET', url: '/' }, res);

  expect(res.writeHead).toHaveBeenCalledWith(200, {
    'Content-Type': 'text/plain; charset=utf-8'
  });
  expect(res.end).toHaveBeenCalledWith('KT3 App');
});

test('GET /health returns status ok', () => {
  const res = { writeHead: jest.fn(), end: jest.fn() };
  app({ method: 'GET', url: '/health' }, res);

  expect(res.writeHead).toHaveBeenCalledWith(200, {
    'Content-Type': 'application/json'
  });
  expect(JSON.parse(res.end.mock.calls[0][0])).toEqual({ status: 'ok' });
});
