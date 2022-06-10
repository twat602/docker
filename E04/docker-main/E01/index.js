const data = {
    id: 8,
    title: 'titre avec fetch',
    author: 'testing docker ho !',
    body: 'body avec fetch',
};

async function testingDocker(data) {
    try {
        const res = await fetch('http://localhost:3000/articles', {
            method: 'POST',
            body: data,
        });

        return res;
    } catch (error) {
        return error;
    }
}

async function getData() {
    try {
        const res = await fetch('http://localhost:3000/articles');

        if (res.ok) {
            const articles = await res.json();

            return articles;
        }
    } catch (error) {
        return error;
    }
}

testingDocker(data)
    .then(() => console.log('done'))
    .catch((e) => {
        console.log(e.message);
        console.log(e);
    })
    .finally(() => console.log('done'));

getData()
    .then((res) => {
        console.log(res);
    })
    .catch((e) => {
        console.log(e.message);
        console.log(e);
    })
    .finally(() => console.log('done'));
