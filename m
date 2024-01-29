Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FD82C1A2
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 18:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706554733; cv=none; b=aTtRgOo90TT2tulMZZMwlVSWBcnom6qhDNgS635Z8npujv+NC5Y5Q9SfJQ9qYNnrR535rYoV+y6ebbNpxyFVMbU9JaLsMMCmGbiDnmS5DJSzny6DUbCrIMvqulVIxX9N1KHjSZCH/kT8VkXA5k1d4EhbxXlbKRVP+Zig+x5W0eA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706554733; c=relaxed/simple;
	bh=eKMFg7i7+7j+e8Iv0NW7ko6n3ZkbnwSwN9MN8KR3iQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QFoMDXTNVTlOoDgFul4qZNnx/ds6spV8dT6NpG2iMNZXuDR5H6wU24evS2VNkCFoasyQWTkFA1UqoyWI0qMM70VZ05PgQ19xxa4yzUraJiUJUd/5ZuNtrDjdxIX3MTRyhunSd/jVNGpGuFgANq8XO9RNdkmvukeXNk+RbpwwRyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OsOLphgX; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OsOLphgX"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-51114557c77so1230885e87.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 10:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706554729; x=1707159529; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lAIeftpjE3O3z+PB+PSTo+RPyGVLY9cTuEJCruuNk/w=;
        b=OsOLphgXcvY9l4lR1zql4yODBK9CiHilNprHE23ita63pWGQxXOny/0C4QEPHkJL4w
         7nHUPf1MNloA2saNS/w1AKU5vBU6rqBmubOBGGuKZeypMJSUr/HtqU08a+kxfahD/FFS
         xA7TZouk9GaxShnH83jZhmiIqb7JOItvxa1KM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706554729; x=1707159529;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lAIeftpjE3O3z+PB+PSTo+RPyGVLY9cTuEJCruuNk/w=;
        b=K0qQHvLY5/Vg2haPbB0eeFhrq4CPLpOCrgdMjwzUP46Q357gcGcZDWoR2QdDbpYliF
         lLfblr/+rbzIi6LepHCAoSCUkgPDzPaLOran6DzObQp6WKGLAPZPVhzSumrg0WH1/iHQ
         hyioVNtIjUtjQUOCNZmDIp9vKh3oShDV/auPE1b+wwy6Js3SsKa6o4mhi5Upjoz54YQT
         ins7EwOt29UB38D8wJTZuwqcuAaKcvIXrvOLBSV8IoERN0HwYNzl7ZU6Ebi3nxD4Moq5
         q0w9RrQJpt0J1l3sBy2+rl8gwpvrpxxt1/UrNw5DMu7AIEEnFmLKBkS0wDP1Gozfo3z4
         Bmmg==
X-Gm-Message-State: AOJu0YyX4xbm6ouGNI+iK0L1ht7c051SeMaZuMbpwxKWILMCiOmeoULL
	UGLaaqoTSAyOSSTuaMp1nkgEr0A+aPZV6h8mXI6HO28MExMEfZklRi3JPkfkOZAZZmP2qv3nmz/
	ppBtf3Q==
X-Google-Smtp-Source: AGHT+IED2KwTsPbscP1dhZb8E6rsPks+r2RjGTIw+dnyQGWjIi+CR26505hf4TJGrGZn8kpoTUJjrA==
X-Received: by 2002:ac2:5b11:0:b0:50e:6c1d:5dee with SMTP id v17-20020ac25b11000000b0050e6c1d5deemr4140946lfn.33.1706554729315;
        Mon, 29 Jan 2024 10:58:49 -0800 (PST)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id eq6-20020a056512488600b0051021c54018sm1187731lfb.251.2024.01.29.10.58.48
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 10:58:48 -0800 (PST)
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2d040a62a76so18043971fa.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 10:58:48 -0800 (PST)
X-Received: by 2002:a05:651c:150b:b0:2cc:9ec8:fc5a with SMTP id
 e11-20020a05651c150b00b002cc9ec8fc5amr5318335ljf.39.1706554727677; Mon, 29
 Jan 2024 10:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
 <8547159a-0b28-4d75-af02-47fc450785fa@efficios.com> <CAHk-=whAG6TM6PgH0YnsRe6U=RzL+JMvCi=_f0Bhw+q_7SSZuw@mail.gmail.com>
 <29be300d-00c4-4759-b614-2523864c074b@efficios.com> <CAHk-=wjpyv+fhxzV+XEQgsC+-HaouKT7Ns8qT31jkpN_Jm84_g@mail.gmail.com>
 <3120f1f0-eaf8-4058-9a65-bdbee28c68c9@efficios.com>
In-Reply-To: <3120f1f0-eaf8-4058-9a65-bdbee28c68c9@efficios.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Jan 2024 10:58:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg8BrZEzjJ5kUyZzHPZmFqH6ooMN1gRBCofxxCfucgjaw@mail.gmail.com>
Message-ID: <CAHk-=wg8BrZEzjJ5kUyZzHPZmFqH6ooMN1gRBCofxxCfucgjaw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 29 Jan 2024 at 08:00, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> This breaks "cp -aH" and "cp -aL".

Do we care? Do we have a user that cares? Has anybody ever hit it?

Why would you ever do anything like that to tracefs filesystem?

In other words: my point is that tracefs just isn't a regular
filesystem. Never was, never will be.

And people should be *aware* of that. We should not say "hey, if it
doesn't work like a normal filesystem, it's a bug".

Try "cp -aL" on /proc, and guess what? It won't work all that well
either. For entirely *different* reasons. You'll get some variation of
"Input/output error"s, and insanely big files and quite possibly
you'll end up with recursive copying as you try to copy the file that
is /proc/self/fd/<output>.

It's just a nonsensical operation to do, and if somebody says "I can't
copy /proc on my system" it's a PEBKAC, not a kernel problem.

The "no regressions" rule is not about made-up "if I do this, behavior changes".

The "no regressions" rule is about *users*.

If you have an actual user that has been doing insane things, and we
change something, and now the insane thing no longer works, at that
point it's a regression, and we'll sigh, and go "Users are insane" and
have to fix it.

But if you have some random test that now behaves differently, it's
not a regression. It's a *warning* sign, sure: tests are useful.

So tests can show when something user-visible changed, and as such
they are a "there be monsters here" sign that maybe some user
experience will hit it too.

So I agree that "just use the same inode number" changes behavior. I
agree that it can be a bit of a danger. But these "look, I can see a
difference" isn't an argument.

And honestly, I have now spent *days* looking at tracefs, and I'm
finding core fundamental bugs that would cause actual oopses and/or
wild pointer accesses.

All of which makes me go "this code needs to be simpler and *cleaner*
and stop making problems".

In other words: tracefs is such a complete mess that I do not care one
*whit* about "cp -aL". I care about "this is actual kernel
instability".

           Linus
