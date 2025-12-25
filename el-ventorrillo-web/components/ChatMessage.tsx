// components/ChatMessage.tsx
'use client';

import { formatDate } from '@/lib/utils';
import { ChatMessage as ChatMessageType } from '@/lib/chat';

interface ChatMessageProps {
  message: ChatMessageType;
  isOwn: boolean;
}

export default function ChatMessage({ message, isOwn }: ChatMessageProps) {
  return (
    <div className={`flex ${isOwn ? 'justify-end' : 'justify-start'} mb-4`}>
      <div className={`flex flex-col max-w-[70%] ${isOwn ? 'items-end' : 'items-start'}`}>
        {!isOwn && (
          <span className="text-xs text-gray-500 mb-1 px-2">{message.senderName}</span>
        )}
        <div
          className={`rounded-2xl px-4 py-2 ${
            isOwn
              ? 'bg-[#002D62] text-white rounded-br-sm'
              : 'bg-gray-200 text-gray-900 rounded-bl-sm'
          }`}
        >
          <p className="text-sm whitespace-pre-wrap break-words">{message.text}</p>
        </div>
        <span className="text-xs text-gray-400 mt-1 px-2">
          {formatDate(message.createdAt)}
        </span>
      </div>
    </div>
  );
}

