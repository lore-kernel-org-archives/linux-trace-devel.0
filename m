Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAC441C93
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 22:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706480284; cv=none; b=KBsNmTvzDwm55fMuU0dtrdgBW6uYyZLnDZNHa/KXGw8ZHnwUVUc2aUCNBOnUY2bbH8wqkejakjreBJs0VPqt9ZaacBbuFW0phPczx232ZU2YO4yY/02eCxj3oXKV7q6f+Qdqt9Z0Sa+7VgpV9u/iUsLhxPpWtiAMK5568zq4jLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706480284; c=relaxed/simple;
	bh=ZAbeqFfkAVPYZBMTPGlMkmzAB7gy9KOSp2nArVSSt/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VR26t0DLnQFGghJXSTC0L9Wz7VAUltTVy+naXSjReJt396l/JmOxTn2fOAmny1ClT1BNReUjIac4h96lTmT3V+KwAtM7lQCOJZjFJKJRWoGxlhQmvpP1bjFwXrjvcykLv75DUSMcEt5zF0n39X+agWXmevY7GAalLS2dSk9KLW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gOoNi/ia; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gOoNi/ia"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a3571318164so90401766b.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:18:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706480281; x=1707085081; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QdJFIrMlzo7zdWhHTFYeNBtmU9mUeMU8Dy6w+dT6xYA=;
        b=gOoNi/iaLala8FW8oQ5fSMfE33yecB93x3rkCHE65YDdFNnw3b8bIzyXD4j11vEXK+
         TxN72k9LGVYGi9S5zNOMB6fOtAIdDYgzcocShl00+hS9z76VNgmLM+xicmjfPUjIxYCe
         TGEEOmmqEvT3VyAhBQtvv/11ZmEKo6225Pt8o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706480281; x=1707085081;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QdJFIrMlzo7zdWhHTFYeNBtmU9mUeMU8Dy6w+dT6xYA=;
        b=fyMJ1GHizjyu5v2u12OCKtoQXvfN9TTn7mVabVQxyQb7PF2mvvDNdTMabbuV9sJ0Rd
         2Ws+sBieyccKrfN1Wto/lDfDXnsneLvnJZwxxTl6MCcTlqalC24mWqY4tkjvYvdR+MLo
         OEZultpx8lNEY7tF9ek7fIQ+cL88+QYDk75a7qs74/z/APoDtnKpZmCTwXytQiYO6Kle
         4OxZ6ZjL3fhquRJ8t/6tT55gppRHOWzOO0Vj6r8W44jTzHbD2kdVgZXB8dfHJ/KViCv3
         1QKlsgjyxQ1yg7BX/DbQzAMxEtNKemS1bF72s0bKNLGDlF40RKr60y3udFawbFQLIunK
         TyCw==
X-Gm-Message-State: AOJu0YxrLJRgjPeuO5gwVwcCM87jwdInFyE7u9Q5abxVqc2s+uYxCHFo
	vcZereMYav/XSx8GZBoKnkrDf+sKHPHKTxsoQKRVUPUFOUbkf/51Kr/IVqPZmU6PHR6YrcP8IzF
	LXhDQGA==
X-Google-Smtp-Source: AGHT+IEyFIBalX3Ux+lh3oQzCPTsr7kchn5LG+ioHqFJZwQf0nxxf/bftggwndxOJUZYkVKUwcpDgg==
X-Received: by 2002:a17:906:36ca:b0:a35:822f:f676 with SMTP id b10-20020a17090636ca00b00a35822ff676mr1846651ejc.39.1706480280713;
        Sun, 28 Jan 2024 14:18:00 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id th8-20020a1709078e0800b00a352fbd1a7fsm2372964ejc.173.2024.01.28.14.18.00
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 14:18:00 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-554fe147ddeso1826103a12.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:18:00 -0800 (PST)
X-Received: by 2002:aa7:d053:0:b0:55f:80a:3006 with SMTP id
 n19-20020aa7d053000000b0055f080a3006mr183783edo.2.1706480279842; Sun, 28 Jan
 2024 14:17:59 -0800 (PST)
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
 <CAHk-=wiWo9Ern_MKkWJ-6MEh6fUtBtwU3avQRm=N51VsHevzQg@mail.gmail.com> <20240128170125.7d51aa8f@rorschach.local.home>
In-Reply-To: <20240128170125.7d51aa8f@rorschach.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 14:17:43 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg0bfqL9Yn-KnamLTvTpw+zbAa=og_JRPjZHgJ5m9iCZA@mail.gmail.com>
Message-ID: <CAHk-=wg0bfqL9Yn-KnamLTvTpw+zbAa=og_JRPjZHgJ5m9iCZA@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 14:01, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Basically you are saying that when the ei is created, it should have a
> ref count of 1. If the lookup happens and does the
> atomic_inc_not_zero() it will only increment if the ref count is not 0
> (which is basically equivalent to is_freed).

Exactly.

That's what we do with almost all our data structures.

You can use the kref() infrastructure to give this a bit more
structure, and avoid doing the atomics by hand. So then "get a ref" is
literally

    kref_get(&ei->kref);

and releasing it is

    kref_put(&ei->kref, ei_release);

so you don't have the write out that "if (atomic_dec_and_test(..) kfree();".

And "ei_release()" looks just something like this:

    static void ei_release(struct kref *ref)
    {
        kfree(container_of(ref, struct eventfs_inode, kref);
    }

and that's literally all you need (ok, you need to add the 'kref' to
the eventfs_inode, and initialize it at allocation time, of course).

> And then we can have deletion of the object happen in both where the
> caller (kprobes) deletes the directory and in the final iput()
> reference (can I use iput and not the d_release()?), that it does the
> same as well.
>
> Where whatever sees the refcount of zero calls rcu_free?

Having looked more at your code, I actually don't see you even needing
rcu_free().

It's not that you don't need SRCU (which is *much* heavier than RCU) -
you don't even need the regular quick RCU at all.

As far as I can see, you do all the lookups under eventfs_mutex, so
there are actually no RCU users.

And the VFS code (that obviously uses RCU internally) has a ref to it
and just a direct pointer, so again, there's no real RCU involved.

You seem to have used SRCU as a "I don't want to do refcounts" thing.
I bet you'll notice that it clarifies things *enormously* to just use
refcounts.

                Linus
