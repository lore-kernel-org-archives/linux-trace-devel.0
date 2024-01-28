Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F233C473
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 22:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706479691; cv=none; b=YJ+0xqpPz3vdmw1fikFPnkIzStXsbitCHlHzEQtaZmIxPBrLGSr5cQb/fiGVjdCR+EFytDoiFMpH9J6pANHVQYYjYLtSqhyGv5j1mndX7Rymbtcl6XUTSSMm6zOfshDxumPb8KJk0n73PwAID9/2kyDyYpuYyyTeWEDkuA1MifA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706479691; c=relaxed/simple;
	bh=QrkyxoSXHYJTqgfXOZsbnZEyWO+kRuXGCx6MVdeKjaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LODkBP9qHg0z/f7wouckm13xz6L17qGWAL706N7VOHOijZuHy4xyLQFzw5H2u9V+3XX+YE88yXJ/UOl88Zq6ezNlnbNf11RB8do+YubUQhIk6jMDk3HQCxYvoMA/eXxWPI2Duln5xyp1lbSDhzftHMNdx4/Cj2aoyf6xj+tK4h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U3FCvQDV; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U3FCvQDV"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-55efe051e4aso422238a12.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706479687; x=1707084487; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4w5EVcmzkmBCRT4EQRf6hOGTNZV4Vu2foNdqvfEoib8=;
        b=U3FCvQDV8wlDZNQrqgPMR6yoI5S4khe4tysgj6L1hYlLrS8Yp2vPLESMrGSTMsSNFH
         1YrqbYeyaCyP9sQ2P6H/4qOcgNYURSTigbIB/fxKQDgnXnrKqIGetSyt+iFkXrg9zyU0
         7D/XwV8lW5yjohpaJATlmJFH1UnSln/8DreEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706479687; x=1707084487;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4w5EVcmzkmBCRT4EQRf6hOGTNZV4Vu2foNdqvfEoib8=;
        b=jnQ81kP0+gVt+nvr+9iNE30GBDwaQtWXuBjqquC0KX3xvfiCrZuUWir1c4bT3ZnU5K
         BuaRx5Ef870W0tp4Z/RMXgs1KRn5SA8OqCwFaS+5ugTY23rs2uXvwd4qwsQ3xHqWRaD/
         9DcMCmp9LfC1Sbu/FiTGTC2P+T2KH1oBWD2JJNW7S+EDXQ8IPIVNnbLdWqorOfkLidrl
         vYvt2i2niBX+dlCvYl4jYJfTcT0HxTtgd5IaDNHXK45sDHoxSj8mxL5a7Cui7//Fj7Gc
         zvthCJbEx76GTbJJ2VMidKyZlCoBNsdGfu/ZC7om/7T+2lw2R2fk2LSEF7TWdPxIjrII
         P6IQ==
X-Gm-Message-State: AOJu0YzN4U9LYZO//RnnO3+0ECA7ebDKjU62PCf/dH39jsonoyLWWXQb
	N1lhIkXn1treLgMMWcmp+VXYjWs4zprUBo/kQtOEiNKWn8lKLTNWTrONhWrgqaZc7dt9ugFd9OQ
	Rt8hk6A==
X-Google-Smtp-Source: AGHT+IEyyK7p32NjB5ePV4F1nsWcJaL/aF6zLKNPwqyy75AD4bcyYBF5HZnAg62zEqnPZCEV5YIvJw==
X-Received: by 2002:a17:906:d8da:b0:a31:6a03:d1aa with SMTP id re26-20020a170906d8da00b00a316a03d1aamr6266284ejb.22.1706479687553;
        Sun, 28 Jan 2024 14:08:07 -0800 (PST)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id k11-20020a1709061c0b00b00a30cd599285sm3230094ejg.223.2024.01.28.14.08.06
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 14:08:06 -0800 (PST)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-55eb1f9d1f0so2293087a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:08:06 -0800 (PST)
X-Received: by 2002:a05:6402:94a:b0:55c:93c1:4a50 with SMTP id
 h10-20020a056402094a00b0055c93c14a50mr4633321edz.13.1706479686311; Sun, 28
 Jan 2024 14:08:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
 <CAHk-=wj+DsZZ=2iTUkJ-Nojs9fjYMvPs1NuoM3yK7aTDtJfPYQ@mail.gmail.com>
 <20240128151542.6efa2118@rorschach.local.home> <CAHk-=whKJ6dzQJX27gvL4Xug5bFRKW7_Cx4XpngMKmWxOtb+Qg@mail.gmail.com>
 <20240128161935.417d36b3@rorschach.local.home> <CAHk-=whYOKXjrv_zMZ10=JjrPewwc81Y3AXg+uA5g1GXFBHabg@mail.gmail.com>
In-Reply-To: <CAHk-=whYOKXjrv_zMZ10=JjrPewwc81Y3AXg+uA5g1GXFBHabg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 14:07:49 -0800
X-Gmail-Original-Message-ID: <CAHk-=whJ56_YdH-hqgAuV5WkS0r3Tq2CFX+AQGJXGxrihOLb_Q@mail.gmail.com>
Message-ID: <CAHk-=whJ56_YdH-hqgAuV5WkS0r3Tq2CFX+AQGJXGxrihOLb_Q@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 13:43, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That's just wrong.
>
> Either you look things up under your own locks, in which case the SRCU
> dance is unnecessary and pointless.
>
> Or you use refcounts.
>
> In which case SRCU is also unnecessary and pointless.

So from what I can see, you actually protect almost everything with
the eventfs_mutex, but the problem is that you then occasionally drop
that mutex in the middle.

The one valid reason for dropping it is the readdir callback, which
does need to write to user space memory.

But no, that's not a valid reason to use SRCU. It's a very *bad*
reason to use SRCU.

The thing is, you can fix it two ways:

 - either refcount things properly, ie when you do that lookup under your lock:

        mutex_lock(&eventfs_mutex);
        ei = READ_ONCE(ti->private);
        if (ei && ei->is_freed)
                ei = NULL;
        mutex_unlock(&eventfs_mutex);

   you just go "I now have a ref" to the ei, and you increment the
refcount like you should, and then you dcrement it at the end when
you're done.

Btw, what's with the READ_ONCE()? You have locking.

The other option is to simply re-lookup the ei when you re-get the
eventfs_mutext anyway.

Either of those cases, and the SRCU is entirely pointless. It  really
looks wrong, because you seem to take that eventfs_mutex everywhere
anyway.

             Linus
