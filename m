Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9632C33CF7
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 21:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706305774; cv=none; b=MHD+Y1Jqalhe8p68NRSuPbPpcaJjg2Zq46Nzgq7it/ImfpIjK64hk4PtKA47PxwVJB14ROA81hD+AlEqnW3/W7qcqJm4qhMeveTmKpQiZn6xJOLZSYEE7Z0GLpI79RagcDxgFmH9mITi4hv6fbAK1+aj0BFsIlVk4uTPWTryetI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706305774; c=relaxed/simple;
	bh=1feBzgxjUm84iiTUiKu7X66LEHmz3gCWzAl4aZvt1MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cwVcgJ8Olc05qNr9Tng+jtGZYLcCzA041hfgw3iC0pY3Rs/M2iBNKeQ93a/W9EvXFC5PcymWdfIquj+NHyLR5gMIIF5/iH6ZTKew40f4VKnb8IQoz95RxwTL4q+Hqth1SH9YrjngLe8JaFl+UbCoPB5lEernR4o7qMlheNFpvJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ITiiXhmu; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ITiiXhmu"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40e72a567eeso22452255e9.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706305770; x=1706910570; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9wu3+xA7CIMWU4XKJQMmnJ1lLlzU5w120Zsjy2ckeYo=;
        b=ITiiXhmudKL1MPHqHwYC1207HInRj/txaj8MxdEN5yhIElN4HKnN3uJ0qy+v0o2vDC
         MbPRgPt5thoZu9pOGm4LdmSMR1mLCpMIlx1d3OhBpd+RWpv5kyBNJYSLaQqeeszBT5OH
         YxD60z5BY0bNA/cPPaOgmdXyhThUliqyMkhm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706305770; x=1706910570;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9wu3+xA7CIMWU4XKJQMmnJ1lLlzU5w120Zsjy2ckeYo=;
        b=HBzQ71N4dOeFbRhMosTPZtn5UEyZOBLwr9192NiT82mdaXeeED87eDinl2cPBk4zpG
         ppwhiiJGNcP9165X7ASAjvxm9Ytoh4gnEiT0iqD8opsXaT9XKnY5OJ0viNCIhP0rcy6Y
         m/nwH6qWc2VJ9CoKZjWNVW3h6uOeTyyzIEpR1OnoINh8f5jMKpWUDoS2lx3jG9D4PlxG
         X8SNgD9UixBsaj614Dg+Wp+14CxWJb50XTlfG5ghKRFCLhfGWb9KTCdg9Mzdrk7zk5M6
         CLm2gs+2/k7R3+36WspgQSThKmZh89svEjeWZAOmgEUPLc+d9VSrGLoF1ntHe/4IGE31
         fXHQ==
X-Gm-Message-State: AOJu0YxWy2wMHTNqwiB5Pa1M6h26bzsdwQBKJI65MTaD+AOmXM7aDY1V
	gyNgItFZ2ImFnpwvYnrhsHV2uvQZA1c8AN8xfx5nXpjqU8bTTBl7ZfIeLF6t2UHhxdt/OscYKyx
	C0pU9FA==
X-Google-Smtp-Source: AGHT+IEUEcGQUt6j6eu0lidhWhs+gxo46nHnB8okDQ/t933CdWEu3sTVRF6OGo0SJkthXFAGWuyxtg==
X-Received: by 2002:a05:600c:2e16:b0:40e:532e:e220 with SMTP id o22-20020a05600c2e1600b0040e532ee220mr203085wmf.269.1706305770727;
        Fri, 26 Jan 2024 13:49:30 -0800 (PST)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id h17-20020a17090634d100b00a312651ff8dsm1041915ejb.157.2024.01.26.13.49.29
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 13:49:30 -0800 (PST)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40eacb6067dso18039285e9.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:49:29 -0800 (PST)
X-Received: by 2002:a05:600c:4a21:b0:40e:9706:9a38 with SMTP id
 c33-20020a05600c4a2100b0040e97069a38mr197355wmp.214.1706305769566; Fri, 26
 Jan 2024 13:49:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
In-Reply-To: <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 13:49:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
Message-ID: <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 13:36, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> If you have more than 4 billion inodes, something is really really wrong.

Btw, once again, the vfs layer function you took this from *does* have
some reason to worry. Somebody might be doing 'pipe()' in a loop.

Also, if your worry is "what if somebody mounts that thing a million
times", the solution to *that* would have been to make it a per-sb
counter, which I think would be cleaner anyway.

But my real issue is that I think you would be *much* better off just
deleting code, instead of adding new code.

For example, what purpose does 'e->dentry' and 'ei->d_childen[]' have?
Isn't that entirely a left-over from the bad old days?

So please try to look at things to *fix* and simplify, not at things
to mess around with and make more complicated.

              Linus
