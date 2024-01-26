Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9242533090
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 23:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706311055; cv=none; b=BntiXgtdqPo1QMSbHgKJokWQr0xqWzspEaJ7BYmDt4v2hn/olp71Pq+z30ug5ESLp3nVPiuhWCdUMfFHUELAHUYaN9pmoGexgupWhxNtiYoydw3oQ11jaBuLUBpQUDM411rp5BjLu5YLJs9gi6HhDiPWzkkriXbfePSb+6kGg6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706311055; c=relaxed/simple;
	bh=QmVspYtlmSmjhcCoSiCpOR9/r0lxSB1GXdq7WVzBRp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ST7VrvTHbbr3vdeiQuZAlJARsWKZRsgcnSWvnbdol1jkh46PeN2/mbHaPdrG/xlhKFkMd3buPCY5x3axvpWCiTjSvWU9T9UODdhFlSRLWkZ1FgO1hUekH68TkX7S3cePiiXLDNaE+ZqM1rGeXItlr6gsFPsyeSPrtv9Pao4F4Bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d40LHoIS; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d40LHoIS"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5100fd7f71dso1961265e87.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 15:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706311051; x=1706915851; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VC+HuLvY2p6RWyDAc32xlp18wOorWJVU3mokVs6SBvk=;
        b=d40LHoIS4y+T0ms9j1nzzyVJhsOKuneM/m4nxqnuR5Jq+f4eAIZwx9e0fm0IzFXn5C
         71zCoHbsgLkJOuxtYPU6sg057jvH/CJpojhhi6+Rpt36EEhLR3VDxB/30pgWYn/uX/mg
         ydJTuf7uoHSg/EurtQu+PtNhhjrPNXQIGuY8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706311051; x=1706915851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VC+HuLvY2p6RWyDAc32xlp18wOorWJVU3mokVs6SBvk=;
        b=eCrNtdZjmwPGvO3fK8rxGBNdyVSQ5G7cEw+b1zZe5ql3R9Rs8IXIz3jsBNxPUhyJSn
         WoLhAAoLheF2ZNRDrUEFPgc5BLSyx2HcUAYgIL5F7aCoNY18N9slnUputhte4wXqBHV0
         vuLch+6s8tJf4xa+ww41sj8B5VuB6PlPRy40lXHyMG5w9KhT44SiPjSsN4oscIa2fxVs
         oJ0YB4L3Np+hw2iSiLt8aEN+nNtVKO8//RHU+1kJ+Vn9bchF9Lwk3+CpYem0y3EpbgI5
         E32qU0sArCOOOg6Eu4i/2QuMZOAEpfgGJrMvNIjnqRQ0LrQbiTg41QvE+G/GtRGDAZrY
         RamA==
X-Gm-Message-State: AOJu0YxRWuMIH5i86tOxtx8rhoctKoILF7pZAsna2vyUzgmcjESXxTmJ
	dQXKVlKBK/1TxiqVItY9hZo7giiPS7FPUwnKDJXhBUv6G1TAB+2h3M1wV/exmlGH5jqZl9UU7Ma
	fc6QDzA==
X-Google-Smtp-Source: AGHT+IFa+8OzPfRkpczw3+IqF0ymmbpj/EWBaAOXU1950N5Z4tBJpF5ec6c7bTCBb03+oS8TJkHddg==
X-Received: by 2002:ac2:4904:0:b0:510:253f:32dd with SMTP id n4-20020ac24904000000b00510253f32ddmr258756lfi.31.1706311051360;
        Fri, 26 Jan 2024 15:17:31 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id v23-20020a197417000000b0051017b24ad2sm311424lfe.245.2024.01.26.15.17.30
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 15:17:30 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2cf4fafa386so5523311fa.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 15:17:30 -0800 (PST)
X-Received: by 2002:a2e:7c19:0:b0:2cf:4a53:90f with SMTP id
 x25-20020a2e7c19000000b002cf4a53090fmr374339ljc.7.1706311050498; Fri, 26 Jan
 2024 15:17:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
 <8547159a-0b28-4d75-af02-47fc450785fa@efficios.com> <ZbQzXfqA5vK5JXZS@casper.infradead.org>
 <CAHk-=wiF0ATuuxJhwgm707izS=5q4xBUSh+06U2VwFEJj0FNRw@mail.gmail.com>
 <ZbQ6gkZ78kvbcF8A@casper.infradead.org> <CAHk-=wgSy9ozqC4YfySobH5vZNt9nEyAp2kGL3dW--=4OUmmfw@mail.gmail.com>
In-Reply-To: <CAHk-=wgSy9ozqC4YfySobH5vZNt9nEyAp2kGL3dW--=4OUmmfw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 15:17:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=whqu_21AnXM9_ohxONvmotGqE=98YS2pLZq+qcY8z85SQ@mail.gmail.com>
Message-ID: <CAHk-=whqu_21AnXM9_ohxONvmotGqE=98YS2pLZq+qcY8z85SQ@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Matthew Wilcox <willy@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Steven Rostedt <rostedt@goodmis.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 15:11, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 26 Jan 2024 at 15:04, Matthew Wilcox <willy@infradead.org> wrote:
> >
> > Maybe we should take advantage of that historical oddity.  All files
> > in eventfs have inode number 0, problem solved.
>
> That might not be a horrible idea.

Note the "might". I don't know why glibc would have special-cased
st_ino of 0, but I suspect it's some internal oddity in the readdir()
implementation.

So considering that we do have that commit 2adc376c5519, I suspect it
would just be more pain than its worth to try to teach user space
about the whole "no inode number" thing.

It might be safer to pick something like -1 instead.

               Linus
