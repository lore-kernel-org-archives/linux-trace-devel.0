Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068678;
	b=Tba6eMTRdNkHuGZ6rm4dWSbzz8ME/waegtlz1DeuluLMVmBjyz26VBXuGYAnxib9G3CO
	 jDwHRNI/wX7NbmuBGve7m0KLdzbVjqxI+J44TkihFhvQY61KTT6Mcuob/+PFBUHYthXFg
	 5ZqR0VgZKUJpypSf0lnqkxM3kvHpLUTo1EtGKUmE3Q3YPBH/eUT+WZWDJldV9bBAZTp1X
	 auYVD11+9bZUgCu2IljYo5xt3qZTGqlg266tbx51h0YZuujpUY6CUHOLP3QRqO1czCT7t
	 bZty6DtC+0kj+ycJ7HKzAHNjz7j1yN8086EfAwRHI4OlAwTndDzpSvS6qUt17q/Aj3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068678;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=smkO+GbbRqE3/m4GeBOgp/xmhdRrrL8IChQOM6arNSg=;
	b=oMHbL0j/dIUAnHcI3SqVAeFa2xuqc2U0BB/EkMNLMBdWz4F1fGMF3aUzku1LQxvteDve
	 SyHnYoHmcMMmK61n+el/deXcMv6ua/fI415GT8a62a8738m7vRNn4PEcXOHCMdl/GvPoZ
	 fIpZkKbX3ut6kV5oYwAk1m3XemPPLCRjJKhKRT8FJlmEdtmmqChylsZ8ZdXQHGgcUTCEw
	 /ziwIxoW8nNSzB4iRss4CFMvSGqlQwlX0Sorh8Vedp1pGnootaRDfuOrP8Ug/mwHI/CIC
	 57QfQ2/Vjocu3RG68q17Mjyf7XFws2Egs85zfZvM4dIveYlYMkfS1Qkl4e5zJNO695Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mDJg4M3j;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4B9606A326
	for <linux-trace-devel@vger.kernel.org>; Sat,  7 Nov 2026 16:24:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C4B9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mDJg4M3j
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a56e05568aso4419685e9.1
        for <linux-trace-devel@vger.kernel.org>; Sat, 07 Nov 2026 08:24:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794068675; x=1794673475; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=smkO+GbbRqE3/m4GeBOgp/xmhdRrrL8IChQOM6arNSg=;
        b=mDJg4M3j9vMXQ1y4TepcJx+Ra0gC6+bJ7vRGVBnngIse2q+jQNL6uPZ46r70pCTy6v
         mT0ZxWxQFVlX+aHHQSIZhnBaBoYx4hdtV0a7Wdq9nRuwRg8tycMYCqi1Z4eKT2EtXnrU
         ju98IenGSEfw/c0iGyfdpe7Tf6IrWKWbUAWGWbtcW3Hb/MBBgCkhmF7Pxukwelb2aZBQ
         7kNs1df94hIURaJizQmz71rQJ67iQIZX0sIjqJf9hJm2tTbCFwy28EEMxHGUmBqwPzyw
         gG+vI6JWhQ71nWL8zB91EgAGSTHxPxBexSf/KMMz60xaawu/rlPwY7vmZQRA7mzpYbc/
         bAOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794068675; x=1794673475;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=smkO+GbbRqE3/m4GeBOgp/xmhdRrrL8IChQOM6arNSg=;
        b=zRgTC6sFgem3OMntnckScSIhL6hv1hxTC+L5qinG8f+4kLzhk9Lm00TNPtAS0k2W9T
         xCScYCXTETv8zR09S3QHa41IAklyJwJAwPBZlxRXjA1x1xV0qs9PX2wPGO7373I1MGGV
         7/0hIctn20Dc7LGSWqHixk3r5qQHS1iZcBHiaNUsxz4gW5FtuoCbfvWH1DTtqmcVHG/S
         alNEi/vkkyo2ixsxgz17pFL6ECQTY2oe42uP4KxOOtuhg2VXLksRWfkw/0KPaDyEL4Zl
         6CgRBUUyaTAjapcsGMEVAn6yo4mVsy4s/FYGekOUvpYUhyzJWunAjdC4wlObJnphUFQA
         JUIg==
X-Gm-Message-State: APuU4Z+/qi3A7EVNDVAiZ/WGt5e2v4uQpj4tLsg6HVRmrnDeitokKXjp
	ksm28fVB1mWCM8aoXFEJJTNcU9sFgVjBtQhns2FkCUFeEaozyfwVy9pl
X-Gm-Gg: AYBFou0a9ZLW7sIxUc7gDUwTwDo2nXz4e0oP9LvXtla2h0GH/AaNMpEicNrj1SQ+bbJ
	XrH0LYOremRr/NdntoRfifQiCtBjy07zyYrNWN2Nc8go4Fy0Pd9c1jqXWvu5Kse4q3seZ1qdU0R
	hFCujnQjmPpoKC7ij2CYNdXqENqp79EPCIHypIrYdU8WNidCgt+/KYJdzPOsrotsiwEeZVpByC+
	4IDnGlX6Qgd7o+uYl0JS833Eml5aplgGKseeed9eSgd16mh7y1/YS+VowOzmkgveh9MWBBzJ0tG
	0CeowpUJlmzsPzd2i5szFWnXoXZIXFvTGcv58rmhnkpfaN8223pi4AjI/SohmdrX9lEohAcqAcl
	rFIZYgt5u8ru+UtAuOm3SaGIuF/kbkPjympJo6NHyDMmDOl4Wg2MTnHCoC6DND1aGk8pWk0vTCl
	Bbq2jcCgr7AfFNpnFv+oOShhjSGWIKP//3vHnDC8UpTTqFrhvfzNl4hKgWv5PW1a5HkEnd4rFXe
	YSxcm48WFkpQE34r/d1DIDrifZogvxY72Uqq0lzwA4NvbVrPKtY058NggVu4Kq1iQGHS8Pb96rD
	x8LLmWwdo7hFGUoYgKZ0wFglw5OwhJ1F0Og+GNL7aaYy8I3rBg==
X-Received: by 2002:a05:600c:a305:b0:4a2:417:7db5 with SMTP id 5b1f17b1804b1-4b6dd54a97cmr82416605e9.2.1794068675280;
        Sat, 07 Nov 2026 08:24:35 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b7c49082b6sm33863995e9.2.2026.11.07.08.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:24:34 -0800 (PST)
Date: Sat, 7 Nov 2026 16:24:32 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
Message-ID: <au9QwCTKOwBCZ7f-@debian>
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
 <20260529144124.14954a5f@fedora>
 <CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
 <20260616164812.5ecda840@fedora>
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616164812.5ecda840@fedora>

Hi Steve,

On Tue, Jun 16, 2026 at 04:48:12PM -0400, Steven Rostedt wrote:
> On Mon, 15 Jun 2026 20:25:08 +0100
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> 
> > Hi Steve,
> > 
> > On Fri, 29 May 2026 at 19:41, Steven Rostedt <rostedt@goodmis.org> wrote:
> > >
> > > On Tue, 26 May 2026 19:42:19 +0100
> > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > >  
> > > > CU_TEST() continues execution even if the test fails. It just records
> > > > that the test has failed and moves on.
> > > > So, when libtraceevent is built in a chroot, it can open
> > > > /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> > > > does not stop so we get a segfault when tep_load_btf() tries to use
> > > > the mapped buffer.
> > > >
> > > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>  
> > >
> > > Thanks, but the real fix is here and I'm applying that one:
> > >
> > >   https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/  
> > 
> > Tried it today, and the test still fails for me.
> 
> Thanks for letting me know. I currently just started a new job and I'm
> a bit overwhelmed. It may be a couple more weeks before I get to this.

Not sure if you had a chance to look at it. I was looking at it now while
updating the Debian package. It seems like btf_init() is failing when its
doing if (btf->hdr->hdr_len < sizeof(*btf->hdr)). Adding a debug there shows,
btf->hdr->hdr_len is 24 whereas sizeof(*btf->hdr) is 32.

Tried on a chroot and also on a VM, both shows the same problem in Debian.

-- 
Regards
Sudip
