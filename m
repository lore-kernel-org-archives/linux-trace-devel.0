Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B807E3C473
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 22:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706480768; cv=none; b=LnXqpPr9hdB5SoBkbGJNfWb0Y9T8s9Q2Q0qv/p0GuVXcVeTgkoZfWJcd9eGZptwSRFKoLCcvQ5JsFzrrfx2FYR46bT8Qkbnq7Oy3o0JynneKSSN8WnNY3kFd/wfJKpKDij5mB6qeCD8SKcMGQ0gGWblMNG6dGJ67crjhob8R6E0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706480768; c=relaxed/simple;
	bh=j+se+h8m73lMZ5bO5OVB41iLFrTcnxKO4rHbaHCahqs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMnauhq6x0M9Y35B+tSg0U77HnH6ad8+oSfVYSgWUx+q8dBZIG7NxYRtrAHrHP6yDY/YqA+KFld9Wne8TVGYjeK09M5ze1qYj/wq9JF1kTRlgu2dWHactP5GPGU7cHzl/GX7bydXCkwdyBlUlYJglEk6HIA2o3C/Xvyppf6b9K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bbD7MrlT; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bbD7MrlT"
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2cf1fd1cc5bso24308031fa.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706480763; x=1707085563; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HN/bf1OB33r34YH/RajJRYZVQ8GWrEHQI2/Udp84+Ew=;
        b=bbD7MrlTlqML9/Lu1+1/SlPk8/CotOQ3MumJe8FjsPvHnt5bM3UxsSu6LDZV+Wus+P
         oUYVHTU/SHSWJvXtxfsxSlGzOVIvxGtrfT0aCU1ytlL5/YuAAlT+nwoS8yMWDaNL3MFC
         ap5Fin0OAo4s9tD+CI4UFcqbYWwx+F8akd1mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706480763; x=1707085563;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HN/bf1OB33r34YH/RajJRYZVQ8GWrEHQI2/Udp84+Ew=;
        b=ZH2PVmc5dZgXgHqAQT43hq93M/iwwC8mjv3pptVkiellez3w74Dyful6xG8oXK0EwA
         xZok6uj+kueo0rz3qI3DJrUYY6dYJJDUMHfU2UvtMyKZ7od81eFbgaIIBn5+g9Ip6xuw
         XtYP6+GLy0bBiV+8Dtghd6GEJAwqfaqTXEQJ9VEQt1fgYAVO02ReF6ovP1x3weZPOZWl
         fGCG+TVZRNviVne0fJlCnmjAzvaDn12lgJI9fpyB8BbSAIJ0PZjt1TY5IGb/91lQgtZL
         j8ow9Oy9ejm43MBoPBj4c3tdLYldvgnTmLe1ycUYhw1QQqgoJQx0Cv961fBBb4kU8a+D
         aZqQ==
X-Gm-Message-State: AOJu0YxNoYX50FyAIniO8cY2WJro2vFQDX5/qerAIuNB6ELTULJ9m7st
	T5dSNVE0q9JSaw9MJ4cIl1ykji8zB/7dmJ0Jcv3JQAliKKzZ+SEmC6UELvh5bwImh/8ciq8finK
	R9Lci6g==
X-Google-Smtp-Source: AGHT+IGRL8Aw5jae5RnlgHORdxYOBVebZaF0U4wcM/IQ4g6wHxpH/EtTxfgfgbwNLZ1kzzmZTMoXkA==
X-Received: by 2002:a2e:b0f6:0:b0:2cf:1f0b:5119 with SMTP id h22-20020a2eb0f6000000b002cf1f0b5119mr3205380ljl.17.1706480763460;
        Sun, 28 Jan 2024 14:26:03 -0800 (PST)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id dj6-20020a05640231a600b0055c0167eb9fsm3109845edb.51.2024.01.28.14.26.02
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 14:26:02 -0800 (PST)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-55ee8e5dd4cso599511a12.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 14:26:02 -0800 (PST)
X-Received: by 2002:a05:6402:3137:b0:55e:b30c:e0db with SMTP id
 dd23-20020a056402313700b0055eb30ce0dbmr2586779edb.35.1706480762366; Sun, 28
 Jan 2024 14:26:02 -0800 (PST)
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
 <CAHk-=whJ56_YdH-hqgAuV5WkS0r3Tq2CFX+AQGJXGxrihOLb_Q@mail.gmail.com> <20240128171733.2ba41226@rorschach.local.home>
In-Reply-To: <20240128171733.2ba41226@rorschach.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 14:25:46 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjc4ieo09KxdUBNXHPB5+LD8XeqhmRVnqf2k8EAx3ZCaw@mail.gmail.com>
Message-ID: <CAHk-=wjc4ieo09KxdUBNXHPB5+LD8XeqhmRVnqf2k8EAx3ZCaw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 14:17, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> The original code just used the mutex, but then we were hitting
> deadlocks because we used the mutex in the iput() logic. But this could
> have been due to the readdir logic causing the deadlocks.

I agree that it's likely that the readdir logic caused the deadlocks
on the eventfs_mutex, but at the same time it really does tend to be a
good idea to drop any locks when dealing with readdir().

The issue with the readdir iterator is that it needs to access user
space memory for every dirent it fills in, and any time you hold a
lock across a user space access, you are now opening yourself up to
having the lock have really long hold times. It's basically a great
way to cauise a mini-DoS.

And even if you now can do without the mutex in the release paths etc
by just using refcounts, and even if you thus get rid of the deadlock
itself, it's typically a very good idea to have the 'iterate_shared()'
function drop all locks before writing to user space.

The same is obviously true of 'read()' etc that also writes to user
space, but you tend to see the issue much more with the readdir code,
because it iterates over all these small things, and readdir()
typically wants the lock more too (because there's all that directory
metadata).

So dropping the lock might not be something you *have* to do in
iterate_shared, but it's often a good idea.

But dropping the lock also doesn't tend to be a big problem, if you
just have refcounted data structures. Sure, the data might change
(because you dropped the lock), but at least the data structure itself
is still there when you get the lock, so at most it might be a "I will
need to re-check that the entry hasn't been removed" kind of thing.

                 Linus
