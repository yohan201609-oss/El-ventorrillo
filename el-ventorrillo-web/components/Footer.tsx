// components/Footer.tsx
import Link from 'next/link';
import Image from 'next/image';
import { Facebook, Instagram, Mail, MapPin, Phone } from 'lucide-react';

export default function Footer() {
  return (
    <footer className="bg-gray-900 text-white mt-auto">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Logo y descripción */}
          <div className="col-span-1 md:col-span-2">
            <div className="flex items-center gap-3 mb-4">
              <div className="relative w-12 h-12 flex-shrink-0">
                <div className="relative w-full h-full rounded-full overflow-hidden">
                  <Image
                    src="/logo_ventorrillo.png"
                    alt="El Ventorrillo Logo"
                    fill
                    className="object-cover"
                    sizes="48px"
                  />
                </div>
              </div>
              <h3 className="text-2xl font-bold bg-gradient-to-r from-[#CE1126] to-[#002D62] bg-clip-text text-transparent">
                El Ventorrillo
              </h3>
            </div>
            <p className="text-gray-400 mb-4">
              Tu marketplace de artesanías y productos de segunda mano en República Dominicana.
              Conectamos compradores y vendedores de manera segura y fácil.
            </p>
            <div className="flex gap-4">
              <a
                href="https://facebook.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-full bg-gray-800 flex items-center justify-center hover:bg-[#002D62] transition-colors"
                aria-label="Facebook"
              >
                <Facebook className="w-5 h-5" />
              </a>
              <a
                href="https://instagram.com"
                target="_blank"
                rel="noopener noreferrer"
                className="w-10 h-10 rounded-full bg-gray-800 flex items-center justify-center hover:bg-[#002D62] transition-colors"
                aria-label="Instagram"
              >
                <Instagram className="w-5 h-5" />
              </a>
              <a
                href="mailto:contacto@elventorrillo.com"
                className="w-10 h-10 rounded-full bg-gray-800 flex items-center justify-center hover:bg-[#002D62] transition-colors"
                aria-label="Email"
              >
                <Mail className="w-5 h-5" />
              </a>
            </div>
          </div>

          {/* Enlaces rápidos */}
          <div>
            <h4 className="font-semibold mb-4">Enlaces Rápidos</h4>
            <ul className="space-y-2">
              <li>
                <Link href="/" className="text-gray-400 hover:text-white transition-colors">
                  Inicio
                </Link>
              </li>
              <li>
                <Link href="/productos" className="text-gray-400 hover:text-white transition-colors">
                  Productos
                </Link>
              </li>
              <li>
                <Link href="/productos?type=artesanal" className="text-gray-400 hover:text-white transition-colors">
                  Lo Nuestro
                </Link>
              </li>
              <li>
                <Link href="/productos?type=segundaMano" className="text-gray-400 hover:text-white transition-colors">
                  El Reguero
                </Link>
              </li>
              <li>
                <Link href="/publicar" className="text-gray-400 hover:text-white transition-colors">
                  Vender Producto
                </Link>
              </li>
            </ul>
          </div>

          {/* Información de contacto */}
          <div>
            <h4 className="font-semibold mb-4">Contacto</h4>
            <ul className="space-y-3">
              <li className="flex items-start gap-2">
                <MapPin className="w-5 h-5 text-[#CE1126] flex-shrink-0 mt-0.5" />
                <span className="text-gray-400 text-sm">
                  República Dominicana
                </span>
              </li>
              <li className="flex items-center gap-2">
                <Phone className="w-5 h-5 text-[#CE1126] flex-shrink-0" />
                <a href="tel:+18091234567" className="text-gray-400 hover:text-white transition-colors text-sm">
                  +1 (809) 123-4567
                </a>
              </li>
              <li className="flex items-center gap-2">
                <Mail className="w-5 h-5 text-[#CE1126] flex-shrink-0" />
                <a href="mailto:contacto@elventorrillo.com" className="text-gray-400 hover:text-white transition-colors text-sm">
                  contacto@elventorrillo.com
                </a>
              </li>
            </ul>
          </div>
        </div>

        {/* Copyright */}
        <div className="border-t border-gray-800 mt-8 pt-8 text-center">
          <p className="text-gray-400 text-sm">
            © {new Date().getFullYear()} El Ventorrillo. Todos los derechos reservados.
          </p>
          <div className="flex justify-center gap-6 mt-4 text-sm">
            <Link href="/terminos" className="text-gray-500 hover:text-white transition-colors">
              Términos y Condiciones
            </Link>
            <Link href="/privacidad" className="text-gray-500 hover:text-white transition-colors">
              Política de Privacidad
            </Link>
          </div>
        </div>
      </div>
    </footer>
  );
}

