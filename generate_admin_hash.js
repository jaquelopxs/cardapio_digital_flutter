import bcrypt from 'bcrypt';

const password = 'administrador120';
const saltRounds = 10;

bcrypt.hash(password, saltRounds, (err, hash) => {
    if (err) {
        console.error(err);
        return;
    }
    console.log('HASH:', hash);
});
