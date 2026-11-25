Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.125.188.122
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795648185;
	b=D9eIJuPy0ze7OP5UbJx6BUfgh7GK/zBQGt6fiAqVcdkArwNU4P4QQVLFcPPhEco1ll9f
	 Bf55qO9lSOuPk7SFZ6PTueoCQ9lWGZ5X2OQ7TlYe+m+5i/La+XYf0xJgOtSXsSCTBAbKo
	 T6E4CMWPOghC3dNE6EZWGZArX2U2hLSVjOsTYnJbCWBiwEWAGtFVKlLefqWIb9vmmPwhN
	 NGdm6A8dbJRSq8scaBFJ14jmbJdkyyD2AqA17UvUGv58eDx2mm9fQVXliKqR5++gn1fjE
	 EvseKg4EHuYeRUV7S6N9lsHBvVvkb8ncPSHqM0wkECCrE/OxmJAg2Z2mulwgm3UTyFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795648185;
	h=DMARC-Filter:Received:DKIM-Signature:Received:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Message-ID:Subject:From:To:Date:Content-Type:
	 Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=yRliqxzJGsc4MnnboEcY+wshAa6MWzl0PdRYwVvtHws=;
	b=eqlKKPNpHH0TlK3xwQDk6UdbfpjDLP7zOYirv1Ndp1DqqZWlfUdb3rLF7doUuRWy4BHT
	 NhF05UGJtC/CTWGWopac8QOVtbirDnvcpcV/HWmwAfIBmZX1/fQXahnOgrc0Jm8qRncRX
	 +5TfxmsENcpjwV8nB039cmHfkiwK8HKKlymlHx3SM7pO+sd/W9BAi+TfWhqdP7+JwH8yB
	 NbeUMXgAcRMqHly0eKECwygv2ju19yIPq8IxTJwQuGrg7IulLrDZGyzu3QMxlgfJLT3S7
	 BcpiR0U9Y6eMitaCmpPr5Tt39wdSQAgfPeewlYCceMbA/ZWf80zf7vctymEYSq+nKyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=canonical.com;
	spf=pass smtp.mailfrom=canonical.com;
	dkim=pass header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=kiJ0Puz8;
	arc=none smtp.remote-ip=185.125.188.122
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E96606A330
	for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2026 23:09:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36E96606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=kiJ0Puz8
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 3A9673FCF0
	for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2026 23:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1795648176;
	bh=yRliqxzJGsc4MnnboEcY+wshAa6MWzl0PdRYwVvtHws=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version;
	b=kiJ0Puz8/Lf7pfn7/3rqg+MtbPnJDnTF7dSijC3KOll5Rg1jJ4JCXxTbQvHzOXo2O
	 1yPIr3vcQBBZhm8fAWgEkSO1ds4t/wFRu6X0QCXsZuWztluWmww+1mTiRhvefSLwIA
	 Uhz7xsafgqpikZPBB0YledS0oFZ8PZWuc5wkVdSioGW9fPcnBIydnPSPzLHGLqoaxH
	 4OFxGm+dJSkAgUk7pTmrjk5JJweEk1rolliWVgayPBunVSwZCEC7bYIYwr/6LvInIL
	 UpFLBR9BRpjl6xEoNg8jwWODcGjnKGoG7ve0PCZhYGHljyOutW6uHk9EAu5f7MoJAU
	 WpaQLAj9USFe9kdBMGl8tkEGv9h6LBfPATjVxJ03kTRYoCDKg76NVM9f5HvDOAFEWO
	 xV51Rlvbau45RzuiVuxOeqH47ZKxGsgJ0BRtzTaMZFfw+st3CicJx04RemqylPti55
	 syASL9jtICoJjhnqWTd5ld7ZKzL+xarEMoPceYQseiYZ7aj+ZvPetlLtGkTjWfsxrR
	 MTsUAXGFeNxAvL+EBV6RqmgoLJkoqp2X1tATXAQuSZqmfXpIh1X31mcBLRUoFscV9U
	 6GvkrCz/z9ZkTcXefUv6NPegTLId2BnpJf+ggzL+XH5cfoExTVciaZxMajoAtweZoC
	 NzQzXj0sG2/cPMmDVCEQN+K8=
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6b3dc91781fso6187728a12.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 25 Nov 2026 15:09:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795648176; x=1796252976;
        h=mime-version:user-agent:content-transfer-encoding:content-type:date
         :to:from:subject:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=yRliqxzJGsc4MnnboEcY+wshAa6MWzl0PdRYwVvtHws=;
        b=JN/j9RxsUGTJQoHqRkzYEwI3KT4SL8ycFg+m/p8UoszEb8xmmuhE53rT7jL7Xm1suJ
         kYOL0i4KdL/MLHNDp+Cj8n018tKnmBurAT2TfNkFQElbHCubIn3Wh1ynMlu1iwjeffFH
         zkDIa9XpZQ2J4BWKz0yJISod6YtnIDii0U1mDJvPEVzl0RfhtjxNil+5Uq826II3P+Ai
         +hbit1QprDTsJT/Yx3fxwcPY+jCjk51s5arD/J9chiHhda0mq42gm5FyjXg+na9KFBWI
         HQPnpZ9WlfmiCsxF3VljhcdpNoSopNCwAl9UJAl5xFouEvqS0mtCFlc4sJQTACsJPpjX
         iZXw==
X-Gm-Message-State: APuU4Z8Z4azM1JeDFstJaFddCaDy0EgYoR7FLHdEW/CbgtiXbYz2qoHz
	gyrRkKRdiq/XUSbUj2kTI4FW4GGpVmuoZWUPEe11kMxebyV3JLlsAGz5Y8hpxgF0r6RySnO+xEz
	bBLpwINNLx3XvqHsKGUszizSbUxp+43Q7aooKN1ksSKhBCy03HkTntTFokH4dEEqEFF0BpSVud/
	5xqVbgsQ5HUAu8Z4CXNV2c
X-Gm-Gg: AZFdTZc/YlFelkVOgKirEFSS0wN2pWFWcl2/PUWwAZPgJTzUQAnvywEKjJmu235cxTZ
	Oe6FUAOcIg4sfU4kOAjrBJP66Dhl+D1BWH5z0qejxwJWXsMeLkETVxlsRrT2dqXFoqbSaVlYJIW
	kI7ARptwfElm6LZl4El4O/KjxupjxpUb9zNkSKq2cqPXR9myfEA4dg+4wcgbX2lanELhdsRvHJx
	qqwd3KLSKdvLRdDmSY99QMMvMV0ugQjK7bs1CdLWkdxWvQpNeTrH3XKzxaMcRr3+iCS/m5ai6a2
	1td83DvQ5ytgtvWOD8rFcXPkbOwTf32jtR+ykMPa7sUaAOVGiwLcp6wwlNXd48mHy7o7oRepJ1x
	VyN9sEoX1LKMGf5SRNID6+H3KUsR1cNlnsQ+FMO+Bo24CLZ0bTnXFE+e29/bDzfJN906rcW3hPN
	p2aif7mO0wYW7Kbv8XgMsNYzMdbpUyu1nBH/Gk76A0bZUpcA==
X-Received: by 2002:a05:6402:13cb:b0:6ba:4bf3:4a2 with SMTP id 4fb4d7f45d1cf-6ba4bf305c0mr12552865a12.17.1795648175817;
        Wed, 25 Nov 2026 15:09:35 -0800 (PST)
X-Received: by 2002:a05:6402:13cb:b0:6ba:4bf3:4a2 with SMTP id 4fb4d7f45d1cf-6ba4bf305c0mr12552852a12.17.1795648175456;
        Wed, 25 Nov 2026 15:09:35 -0800 (PST)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370cb764sm9249129a12.12.2026.11.25.15.09.34
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 15:09:35 -0800 (PST)
Message-ID: <52df393248e25eb5460bf3bac97352e4845732bc.camel@canonical.com>
Subject: Spelling mistakes in libtraceevent
From: Benjamin Drung <benjamin.drung@canonical.com>
To: linux-trace-devel@vger.kernel.org
Date: Thu, 26 Nov 2026 00:09:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-9 
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Hi,

lintian in Ubuntu found some spelling mistakes in libtraceevent:

I: libtraceevent-doc: typo-in-manual-page endianess endianness [usr/share/m=
an/man3/kbuffer_alloc.3.gz:67]
I: libtraceevent-doc: typo-in-manual-page formated formatted [usr/share/man=
/man3/trace_seq_init.3.gz:65]
I: libtraceevent-doc: typo-in-manual-page formated formatted [usr/share/man=
/man3/trace_seq_init.3.gz:67]
I: libtraceevent-doc: typo-in-manual-page isnt isn't [usr/share/man/man3/te=
p_parse_saved_cmdlines.3.gz:53]
I: libtraceevent-doc: typo-in-manual-page mulitple multiple [usr/share/man/=
man3/kbuffer_read_event.3.gz:49]
I: libtraceevent-doc: typo-in-manual-page retuns returns [usr/share/man/man=
3/tep_parse_saved_cmdlines.3.gz:62]

--=20
Benjamin Drung
Debian & Ubuntu Developer
