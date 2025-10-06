// Run this in the analysis tool to create placeholder profile images
// This creates simple colored circle placeholders

const fs = require('fs');
const { createCanvas } = require('canvas');

// Create a simple colored circle as placeholder
function createPlaceholderImage(color, filename) {
  const canvas = createCanvas(300, 300);
  const ctx = canvas.getContext('2d');
  
  // Fill background
  ctx.fillStyle = color;
  ctx.fillRect(0, 0, 300, 300);
  
  // Draw circle
  ctx.beginPath();
  ctx.arc(150, 150, 120, 0, 2 * Math.PI);
  ctx.fillStyle = '#FFFFFF';
  ctx.fill();
  
  // Draw person icon (simple)
  ctx.fillStyle = color;
  ctx.beginPath();
  ctx.arc(150, 130, 30, 0, 2 * Math.PI);
  ctx.fill();
  
  ctx.beginPath();
  ctx.arc(150, 190, 50, 0, Math.PI * 2);
  ctx.fill();
  
  return canvas.toBuffer('image/png');
}

// Create 4 placeholder images
const colors = ['#A3FF05', '#FFC403', '#FF730F', '#FF0F3B'];
const path = 'C:\\Users\\Hp\\Desktop\\BMS\\bms\\assets\\images\\';

colors.forEach((color, index) => {
  const buffer = createPlaceholderImage(color, `profile${index + 1}.png`);
  fs.writeFileSync(path + `profile${index + 1}.png`, buffer);
  console.log(`Created profile${index + 1}.png`);
});

console.log('All placeholder images created!');
