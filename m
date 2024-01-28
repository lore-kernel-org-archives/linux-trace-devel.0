Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE62B38DFE
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 21:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706476157; cv=none; b=ZxRghklPJEvf8oTkbjpQWzu1L0ZrvoDcwY3IR6WbG8HEbd6/2hnGKLxzcipvRukNjk1aWkHtNiDIpuKExhCzdws7CbzwLAcxMNAUbdwB+3MHjmbsXTUqfrFkhqx0v/1SbHvha0YHJ1N74xkHvT0JB/VicrFVIhMU9btrBJ8KKs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706476157; c=relaxed/simple;
	bh=o4RRkX5gCxLFuN2ynOpDSrsGXRB6T46LcRbk3K1Vsoo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ihOxunrBtIVnPel9MChihjInrSmMyPGllCF0yHX0HBgk6VaeeAbUNYxavxzfBQLHvtmKHNaEtloJ7f1kLP4N22M9PEA92HIgxDQDOG90eDS8+D9x63BOTE9SgWO3HMDzIY2Z2v/uMNFbjIIDeFnlEqG38ImYRS3b+woiT40zoco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=c5acEvq4; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="c5acEvq4"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d03fde0bd9so10636331fa.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 13:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706476153; x=1707080953; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8d+KpAUb3yjw2hNji3XL+yeN/4QOnDBQuqnD1AB0yzU=;
        b=c5acEvq4YSO6L7A8vsPasCXG6MuIgJ4rbUeGkRbh0ETo3EZY74wjgQM4Q/M2LiryX/
         4ECAJ45lq8OQzWkNmaYkS2m5ZkxjFeEYOyeYzwkSBMNvC2AR/pQ0gWT23hP7JWeRor6H
         ALelJ96AOBh8hkI2qjNIiXOtX0s+tGyduWZJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706476153; x=1707080953;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8d+KpAUb3yjw2hNji3XL+yeN/4QOnDBQuqnD1AB0yzU=;
        b=JQnD0oPOvEG6cRiTiN/k2DxX5ryRLgtpKEcsuJZRTfVS34cNy+C/5Xneirnyuej94S
         NFv6z+cAFSgfVXpPWZblQZDBiBMXjnkAE2RQDLzwqet0qRTOHC/5ODxh4uJqXjiJBC2B
         lMwhAYVqe57SCZBgTiNzqRE3juE3Mram94AUrb5zBgWpqAkKrwbYQwJKNfp0OmwBO1sf
         hQSBWe0gFk0E3eemwdHDNGgjc24r4ADUQdb++tNlOxRiP3Zy8Qi9jMzBX9RcbjH+6efa
         yssdDtoQNM6X68RbgjsvNR9XKtgDsPgkoZqmPdKdCy3Ud6IbaR/Ct6AtpGuca/SHFRu/
         Bnbw==
X-Gm-Message-State: AOJu0YyOuYGR68sKNrqX/+0SXRPNT1/phCt0HZdFDdvt++/T3wfYJozQ
	wH13Yjfqr5daFIL9mD9odE4ZeoqNGCcTfVHUkxAk0H1iwwbcF51FlfCW6gTUjRKrpiFtNSr+mrQ
	OUIg=
X-Google-Smtp-Source: AGHT+IGEh0E1i29LbctdFarUGPKteOAiFV8mWNWNAMAw5B4KS4rwI8ha8NG5Y8X+eFQS/wOVj01AMg==
X-Received: by 2002:a19:6452:0:b0:50e:7d27:f930 with SMTP id b18-20020a196452000000b0050e7d27f930mr3579709lfj.29.1706476153557;
        Sun, 28 Jan 2024 13:09:13 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id a3-20020a19f803000000b005100fb026dbsm887518lff.146.2024.01.28.13.09.12
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 13:09:12 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2cf59559b2fso7579661fa.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 13:09:12 -0800 (PST)
X-Received: by 2002:a2e:b254:0:b0:2ce:926:f651 with SMTP id
 n20-20020a2eb254000000b002ce0926f651mr3165518ljm.1.1706476152131; Sun, 28 Jan
 2024 13:09:12 -0800 (PST)
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
In-Reply-To: <CAHk-=whKJ6dzQJX27gvL4Xug5bFRKW7_Cx4XpngMKmWxOtb+Qg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 13:08:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiWo9Ern_MKkWJ-6MEh6fUtBtwU3avQRm=N51VsHevzQg@mail.gmail.com>
Message-ID: <CAHk-=wiWo9Ern_MKkWJ-6MEh6fUtBtwU3avQRm=N51VsHevzQg@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 12:53, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now, the RCU delay may be needed if the lookup of said structure
> happens under RCU, but no, saying "I use SRCU to make sure the
> lifetime is at least X" is just broken.

Put another way, the only reason for any RCU should be that you don't
use locking at lookup, and the normal lookup routine should follow a
pattern something like this:

    rcu_read_lock();
    entry = find_entry(...);
    if (entry && !atomic_inc_not_zero(&entry->refcount))
        entry = NULL;
    rcu_read_unlock();

and the freeing should basically follow a pattern like

    if (atomic_dec_and_test(&entry->refcount))
        rcu_free(entry);

IOW, the *lifetime* is entirely about the refcount. No "I have killed
this entry" stuff. The RCU is purely about "look, we have to look up
the entry while it's being torn down, so I can fundamentally race with
the teardown, and so I need to be able to see that zero refcount".

Of course, the "remove it from whatever hash lists or other data
structures that can reach it" happens before the freeing,

*One* such thing would be the "->d_release()" of a dentry that has a
ref to it in d_fsdata, but presumably there are then other
subsystem-specific hash tables etc that have their own refcounts.

And a side note - I personally happen to believe that if you think you
need SRCU rather than regular RCU, you've already done something
wrong.

And the reason for that is possibly because you've mixed up the
refcount logic with some other subsystem locking logic, so you're
using sleeping locks to protect a refcount. That's a mistake of its
own. The refcounts are generally better just done using atomics (maybe
krefs).

               Linus
