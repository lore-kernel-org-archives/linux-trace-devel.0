Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF083C08A
	for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 20:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706475234; cv=none; b=Q1CoEe+MdwghE+Za2Anb8rsgxHOeHWJPq2lWVJu4JEA36s0QsGdlWg5zYhkQnDgpu7UggfLvlDZeY9oU1Xek1bUnyXAg3CVUTfkYrbboArNws0lGZIA4PcMwJ6WutQhb/DB+5Tdj3gFlXmxH69FROmF6fzmm+qXvY6FtuC3+5U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706475234; c=relaxed/simple;
	bh=OPL25mOEMBzNyt0G9tcDF3mdQkqE/LMmusy0WyFodYA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JtV0YCKt4+fkaYXdS16gvmSythZ7KNkLSFb4Gu5cOzpybmWO3p4b5cSDYR1yiE00Ym99V4AzBJCWi7S+Doa5yytrrd5L8gDYXYzJJ/if+CzcHf0zQNr1lfN8R6+tMBDQDxktzN8oc2hKBmflERpQbWlru2W6ar99VyIjEgxCN90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h5vuX8Ys; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h5vuX8Ys"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-510f37d6714so1101791e87.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 12:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706475230; x=1707080030; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BrezTTnj7N/Ys+Vw7pUL8AQ9OmNzc9NBDGdrHuRcsMA=;
        b=h5vuX8YsxB/SLHF3J9Gl0lWlYe3aBqPcZkUAwo0C0csow47/EE/MPhMB3FBCQDgWA8
         H60bx22CnjYB09c2KtCI6oagzPRAnoCjrb9kgXMVaQKQHfW+vH1pAK152BfzWMDn0JDh
         u8Md++6eBnW2c+EL3ZubZAXq050CBBE4cfmYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706475230; x=1707080030;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BrezTTnj7N/Ys+Vw7pUL8AQ9OmNzc9NBDGdrHuRcsMA=;
        b=U6/VVQEWqokFw7w5Z8cnObRN1sDJnkJnr1nRt8SGWJ1VmqAfLru/uVbZU0cLgND7kU
         WzLiWfXU9DVhc1Vijn93wMesJvvfVvWLraeqwQNPaFHa2+gMQ11pduLC3S930T5BZllV
         Tq+dnCMIQ6Rc2tgck3O6vVlZijRPtP34D0/jBQTVfIxe8vxgGCDHFGdABpcml+OvdtAJ
         DdxC+TGpQFZu4NoUFt2upxDsd038M3JCZ8P+3gFUMLTGgiZI2jwxJBlBN1QS5JT/8mtt
         EYFq6yCjL4r7Tf0y4kLkgZEwy4MHMAk06SstIyMs/3nkdHFjVvWE439cneZn8LO9hVCY
         6mSg==
X-Gm-Message-State: AOJu0YxV9ujJL6WUL+0VZvj3DRrSlF9eAV7rg1YLLfDvX4wSSEkN1fqT
	KXU8fhIrvFTl4kEoN8QEsO2JGZESqhx0dCLU20LNdjbNVI0vE/ac1QiVL4FM46N58IRsFJM1NG3
	pzho=
X-Google-Smtp-Source: AGHT+IGpwHT/9vmcBclxE8Zs9xTlBOZwiJ8MsBcJg3b3PItlPGeZmPIurYsBOUovt1nWIrzRB0Ex9g==
X-Received: by 2002:a19:7506:0:b0:510:6e7:6999 with SMTP id y6-20020a197506000000b0051006e76999mr2524513lfe.45.1706475229855;
        Sun, 28 Jan 2024 12:53:49 -0800 (PST)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id en26-20020a056402529a00b0055823c2ae17sm2975613edb.64.2024.01.28.12.53.48
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 12:53:49 -0800 (PST)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-55f082c2c92so51777a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 12:53:48 -0800 (PST)
X-Received: by 2002:a05:6402:88f:b0:55f:8fb:f41a with SMTP id
 e15-20020a056402088f00b0055f08fbf41amr54301edy.8.1706475228498; Sun, 28 Jan
 2024 12:53:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
 <CAHk-=wj+DsZZ=2iTUkJ-Nojs9fjYMvPs1NuoM3yK7aTDtJfPYQ@mail.gmail.com> <20240128151542.6efa2118@rorschach.local.home>
In-Reply-To: <20240128151542.6efa2118@rorschach.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 12:53:31 -0800
X-Gmail-Original-Message-ID: <CAHk-=whKJ6dzQJX27gvL4Xug5bFRKW7_Cx4XpngMKmWxOtb+Qg@mail.gmail.com>
Message-ID: <CAHk-=whKJ6dzQJX27gvL4Xug5bFRKW7_Cx4XpngMKmWxOtb+Qg@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 12:15, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> I have to understand how the dentry lookup works. Basically, when the
> ei gets deleted, it can't be freed until all dentries it references
> (including its children) are no longer being accessed. Does that lookup
> get called only when a dentry with the name doesn't already exist?

Dentry lookup gets called with the parent inode locked for reading, so
a lookup can happen in parallel with readdir and other dentry lookup.

BUT.

Each dentry is also "self-serializing", so you will never see a lookup
on the same name (in the same directory) concurrently.

The implementation is very much internal to the VFS layer, and it's
all kinds of nasty, with a new potential lookup waiting for the old
one, verifying that the old one is still usable, and maybe repeating
it all until we find a successful previous lookup or we're the only
dentry remaining.

It's nasty code that is very much in the "Al Viro" camp, but the point
is that any normal filesystem should treat lookups as being concurrent
with non-creation events, but not concurrently multiples.

There *is* some common code with "atomic_open()", where filesystems
that implement that then want to know if it's the *first* lookup, or a
use of a previously looked up dentry, and they'll use the
"d_in_lookup()" thing to determine that. So this whole "keep track of
which dentries are *currently* being looked up is actually exposed,
but any normal filesystem should never care.

But if you think you have that issue (tracefs does not), you really
want to talk to Al extensively.

> That is, can I assume that eventfs_root_lookup() is only called when
> the VFS file system could not find an existing dentry and it has to
> create one?

Correct. For any _particular_ name, you should think of lookup as serialized.

> If that's the case, then I can remove the ei->dentry and just add a ref
> counter that it was accessed. Then the final dput() should call
> eventfs_set_ei_status_free() (I hate that name and need to change it),
> and if the ei->is_freed is set, it can free the ei.

Note that the final 'dput()' will happen *after* the dentry has been
removed, so what can happen is

   lookup("name", d1);
   ... lookup successful, dentry is used ..
   ... dentry at some point has no more users ..
   ... memory pressure prunes unused dentries ..
   ... dentry gets unhashed and is no longer visible ..
   lookup("name", d2);
   ... new dentry is created ..
   final dput(d1);
   .. old dentry - that wasn't accessible any more is freed ..

and this is actually one of the *reasons* that virtual filesystems
must not try to cache dentry pointers in their internal data
structures. Because note how the fuilesystem saw the new lookup(d2) of
the same name *before* it saw the >d_release(d1) of the old dentry.

And the above is fundamental: we obviously cannot call '->d_release()'
until the old dentry is all dead and buried (lockref_mark_dead() etc),
so pretty much by definition you'll have that ordering being possible.

It's extremely unlikely, of course. I'll be you'll never hit it in testing.

So if if you associate some internal data structure with a dentry,
just *what* happens when you haven't been told abotu the old dentry
being dead when the new one happens?

See why I say that it's fundamentally wrong for a filesystem to try to
track dentries? All the operations that can use a dentry will get one
passed down to them by the VFS layer. The filesystem has no business
trying to remember some dentry from a previous operation, and the
filesystem *will* get it wrong.

But also note how refcounting works fine. In fact, refcounting is
pretty much the *only* thing that works fine. So what you *should* do
is

 - at lookup(), when you save your filesystem data in "->d_fsdata",
you increment a refcount

 - at ->d_release(), you decrement a refcount

and now you're fine. Yes, when the above (very very unlikely)
situation happens, you'll temporarily have a refcount incremented
twice, but that's kind of the *point* of refcounts.

Side note: this is pretty much true of any kernel data structure. If
you have a kernel data structure that isn't just used within one
thread, it must be refcounted. But it'as *doubly* true when you save
references to something that the VFS maintains, because you DO NOT
CONTROL the lifetime of that entity.

> The eventfs_remove_dir() can free the ei (after SRCU) if it has no
> references, otherwise it needs to wait for the final dput() to do the
> free.

Honestly, you should just *always* do refcounting. No "free after RCU
delay" as an alternative. Just refcount it.

Now, the RCU delay may be needed if the lookup of said structure
happens under RCU, but no, saying "I use SRCU to make sure the
lifetime is at least X" is just broken.

The refcount is what gives the lifetime. Any form of RCU-delaying
should then be purely about non-refcounting RCU lookups that may
happen as the thing is dying (and said lookup should *look* at the
refcount and say "oh, this is dead, I'm not returning this".

> I think the ei->dentry was required for the dir wrapper logic that we
> removed.

I think all of this was due to the bogus readdir that created dentries
willy-nilly and without the required serialization.

And that was all horribly broken.  It wasn't even the above kind of
"really subtle race that you'll never hit in practice" broken. It was
just absolutely broken with readdir and lookup racing on the same name
and creating an unholy dentry mess.

            Linus
