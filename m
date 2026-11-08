Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794135780;
	b=oChORGjIK6Z5QRNiIfcPZ6N1WrxffwpRm2zA/bzeGwkW62UMd54R1ukEl26x6fzRqQYJ
	 0jipkHXnLjJR8KeofPIsgiw2AAi7DjoFJ/mIpC9fQzDQ0TobcO54QCuypWZ3cBiuHOvHS
	 WUHRUhPgW8+R1GOWlznUwe64rb1gx4Lrl6dCDVtixAfnYn1lClVoofUSha9T443ZquCRd
	 Kz1vBqs2RzC8ZdfKs4SkD/6XdmnJ08kQC3TN3bkoLiUyDRO0CQeo2KMEfqIxocVsgd2wh
	 waawN0W3WetXiQUb63IUSMynqaeWIvSVzYRf3RSwr7mHdn2t1nD2OxMAP8g5xSM+IlQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794135780;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=5KoAx1FxhlqEIzMjLSzsW7Qwnu8VWqxD4lLfZukB4/g=;
	b=X73bZM47AdZvV9hfqLraO3av/cpyk6FtE76aJ/rvXAWg6xtPE3+cne4GnfJrba/V5z3c
	 WntIEZv1VvKDWyVNqwTKaIyQyxp2xwYGIZzSiGr8i+NsCEhwq+QX7w/vNovDX+nTM76cY
	 kS1PdIsX/M2jHmJPaxqqz9cawKRrtTZxfJqMZ7N3G6pNJHeluKHrv9HBPsbdCkSMlIz2i
	 QvCsxOJ/ZdX09OOFk8NVuWzHm8iAqWxCEw96dhqbVRS1FXPUl3CPngN4HvkM2cn1veELn
	 WVOUHVAug8qNvj9yA4nGZ/SrTI2tnsOHH409j951Ia+g4FZJ3ME0cOb2iEBcvCbzKfQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m+JuBnHs;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC532606A31C
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Nov 2026 11:02:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC532606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=m+JuBnHs
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-66fc7e0ab25so166d50.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 08 Nov 2026 03:02:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794135779; cv=none;
        d=google.com; s=arc-20260327;
        b=qhu8us2ynAg+GoCE+TWltnjf9DDYliB9z9wSsNy5aPDi1KxdITbEX+xQaJE9ni2tQg
         NQaFQUV+mdKWaxFzkOB2Ery547hHDt1wVr6XkI+o1wwXZ/nLNEx2aTQm2kREVGU+baH8
         vIAhxLFZSeLtHV0+dRtrsb60Y6EqCUz97qfvhMzxJs7Gsc9JGfqqP7J8NpN7RcnPRWft
         fZP/QSTrwnyD4TGNeVk1v5fuOm9FLGruid0Wb60eRnB+8rBbwqe2P6zUpBvNtk86usW9
         SfBjZcO92dzVQr2AdQojG1DZkZCgUUzLT7vw2JOz/RV5fwU3QqRpAtketClWlnugVFUN
         pwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=5KoAx1FxhlqEIzMjLSzsW7Qwnu8VWqxD4lLfZukB4/g=;
        fh=jXNTMpgLrQ+IoSG+YU+ClMKPuQbYdElqaX/erLz3aOM=;
        b=ZjUOUjtxOPqykVCBtQKSEUtaZVIZ89+SFu6l+xpGktRuDLKnXipyFMl8+JmVv9T7up
         n6TYImx+mXKhNySW9KeGY5L8HyCmRQm8tmoAT0EsfZyUqUcxKGCBxkOMfOdMj5+jK3Jp
         Z+ZKJg2XLoxAO/yR9q5qN5FVOe2tBg0m83+IydrGTPea9Hwyy2BwAUv+u0f3YMd+juu3
         7/SoJMZQUFTT8Ugkpq0EcECTvTbHUkzRv+/En2Ch4+/Qq+mItGMYSrUGqw+VJ6/Tn4LB
         eqJ/3gJvFvXPDcgxenbuAPsVG+LSzMr2clNcKr0T4mI2SOkliWYeSRM3jHfBIyWnC5hD
         tnDg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794135779; x=1794740579; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5KoAx1FxhlqEIzMjLSzsW7Qwnu8VWqxD4lLfZukB4/g=;
        b=m+JuBnHsAl2MgOAG2S5wiPeHYjQsm+2lwXSWoGZwihVEW+NDR2142aoXjAEvOi95oY
         WpwcNljwhVfUQxbuqxZIXUpS0zL/6Rsi4g4wEYXFI53o3RY7iYyeRJIYp69iAUTa2oBn
         e/URzlybjEPDQKJqTXXNT5L6t6RoLI9OxeUbOjPgTRc6T05UonAlNVM/eS+gel/UVYck
         OyyzTvKnDL2tfG0sE6bNZ6UcYCUebiC3OUBcIhxwy3samN3xwB2ZRAV4HabTHqHKxUfX
         z0Zp7E1/n4HCkVRHirFJgwo+6fxO1NfPKQzPG7OmTels8L05y9ajEn4NyrJ3GWUSHNJm
         kyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794135779; x=1794740579;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5KoAx1FxhlqEIzMjLSzsW7Qwnu8VWqxD4lLfZukB4/g=;
        b=v5lgeknOhAWMvovUhxK5aTOOPoNzJ0LH887RmFTZ+6IaldmMvk/UcorsyTdyYtUF2u
         PIoHaDX5LUlg7OMCAzRULk+AiG/8Ip/6CBYOpsOkdLu4nORJuUYQPNUQyzj2rujGPIg2
         rZ4S1q86irwn5ccyhOuWTGx5o9hBqqzrdRQnH2FupBzFvQQk3fPgsSLI9VCQU9rFbP3k
         /pnrlag4OW7+5vo5hGkBJSvgnk7BmYUVCX/3TpYa4wEV15PTkFFUYmG+0W75xz40kCMJ
         xp6OMlPOtyha423HEJBgMppqaWYx+4hwaY5pgjDh8jgwVdaf6AKcyTCkE8szs8YI0nOe
         6VqA==
X-Gm-Message-State: APuU4Z/HSdWc+xlrUvmJ/EnWmD09r8+h1JTLKvmifPYDfxVHt6qbgLhz
	ShpCTO2Hq9WUOjkAdVzY+fqkDEbq6l7Uqkn1eHlUh8wNamIh7QeDAJ1OLtxHFbixv13BaIlN1Tu
	XEO45gwOg/HCca9S83U6K1bZlKbBDsNA=
X-Gm-Gg: AYBFou1TQhWMJdXe2hcwlbo3bGU4TudIlMRrRfM5/foFzpXte/MtVLB/8L77g3HUIUf
	NrMOs0M4guaFsGKqKRgDcGjqbd9NBGs00Q5rlQvj7lXbYGjJthvwBSI0kTfPulBKn/sBL5GaXV3
	ey5zaXAp6UiYYEkHUDQ4JG/LZWVBoSIOzAklNm755GssMohwvzez93MOc+Orx99H614Cv/lz8XR
	ynoQsaC0dHGYRwuTeAlT88JqDZPOaGtBbYCKENN1tvTwvnIjtuZmgcJbT3O48sGq6+PTWZJQxmK
	yCPRmk0ZWgdM3sYBOLyfzjUxTKCIZdhZjs4gvw0mJXCr5oIjsHifh/IWiL0Y9zuoXnV0kRjTGq6
	mUJmJPe/1ruj+XTpBr2m6on8vy0tVCWDpuOKlMHJKHwO/MyRbpWN2E/gKPQQ=
X-Received: by 2002:a05:690c:4d8a:b0:8ab:3f98:28d2 with SMTP id
 00721157ae682-8b36c6971dcmr13286967b3.0.1794135778757; Sun, 08 Nov 2026
 03:02:58 -0800 (PST)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260526184219.408223-1-sudipm.mukherjee@gmail.com>
 <20260529144124.14954a5f@fedora> <CADVatmMUERxEkbURZuZfTw+UYB2YCMVxK9nvc-z-u5kKNHxM=g@mail.gmail.com>
 <20260616164812.5ecda840@fedora> <au9QwCTKOwBCZ7f-@debian> <20261107162022.65256a9d@fedora>
In-Reply-To: <20261107162022.65256a9d@fedora>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Sun, 8 Nov 2026 11:02:21 +0000
X-Gm-Features: AclHuK8MqkS3xBw4wBWFB1SI3oVaP8yu33wU3GsW4eKqbOfEA1aF4_iCgPk0cO4
Message-ID: <CADVatmP=VDpyw89GUPaoJ94+4roHQxwvENvj3fwSNnczK_9sJQ@mail.gmail.com>
Subject: Re: [PATCH] libtraceevent utest: exit test if mmap fails
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org, Emil Thorsoe <ethorsoe@tuxera.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 7 Nov 2026 at 21:20, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Sat, 7 Nov 2026 16:24:32 +0000
> Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
>
> > Hi Steve,
> >
> > On Tue, Jun 16, 2026 at 04:48:12PM -0400, Steven Rostedt wrote:
> > > On Mon, 15 Jun 2026 20:25:08 +0100
> > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > >
> > > > Hi Steve,
> > > >
> > > > On Fri, 29 May 2026 at 19:41, Steven Rostedt <rostedt@goodmis.org> wrote:
> > > > >
> > > > > On Tue, 26 May 2026 19:42:19 +0100
> > > > > Sudip Mukherjee <sudipm.mukherjee@gmail.com> wrote:
> > > > >
> > > > > > CU_TEST() continues execution even if the test fails. It just records
> > > > > > that the test has failed and moves on.
> > > > > > So, when libtraceevent is built in a chroot, it can open
> > > > > > /sys/kernel/btf/vmlinux but fails in mmap stage and since CU_TEST()
> > > > > > does not stop so we get a segfault when tep_load_btf() tries to use
> > > > > > the mapped buffer.
> > > > > >
> > > > > > Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> > > > >
> > > > > Thanks, but the real fix is here and I'm applying that one:
> > > > >
> > > > >   https://lore.kernel.org/all/d6e07cd6-cb78-4119-a048-920ca58b4830@tuxera.com/
> > > >
> > > > Tried it today, and the test still fails for me.
> > >
> > > Thanks for letting me know. I currently just started a new job and I'm
> > > a bit overwhelmed. It may be a couple more weeks before I get to this.
> >
> > Not sure if you had a chance to look at it. I was looking at it now while
> > updating the Debian package. It seems like btf_init() is failing when its
> > doing if (btf->hdr->hdr_len < sizeof(*btf->hdr)). Adding a debug there shows,
> > btf->hdr->hdr_len is 24 whereas sizeof(*btf->hdr) is 32.
> >
> > Tried on a chroot and also on a VM, both shows the same problem in Debian.
> >
>
> Bah, because I thought the fix was elsewhere I marked it as
> "superseded" and forgot I did that. When you said it was different, I
> was traveling and didn't bother to check patchwork to reset it back to
> New.
>
>    https://patchwork.kernel.org/project/linux-trace-devel/patch/20260526184219.408223-1-sudipm.mukherjee@gmail.com/

The  patch which superseded it seems to be correct, mmap fails and it
copies the content to a buffer and uses that buffer.
But for some reason the len and size does not match. So decided to
flag it to you instead of disabling the test in Debian package. So, it
should ideally be a new issue.

-- 
Regards
Sudip
