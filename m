Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E065EEB5
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 01:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706490030; cv=none; b=n0FdQyYGPayFOW6UOI6ZsZ8qxC/JnZIWfIzLD/D0bSOBmn7hyapQiE8GZLDJR0IkBUC5DRVFVC+BYV00SLNdSPluShBxW1U44yGazb2ygnBQmYv9JtFhwYF2JKzPisTQItolmgQWQ/7LgiFXkKrvyUanZmYC9+8EROzU075Nfdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706490030; c=relaxed/simple;
	bh=YV/bcQkrjkJZfVbuHo0SUwf0M9gitRb1norNvaA7gns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H5ponAtBYZcIASVOqMsC4gPniUjgTxVsgL9X7ZGGmfcRIzAgIyo+iLCUFIgMsEO86gzdzvvxTD1i8YWsrwv9ubQWPh89XozXX3jsDtW1xIMFsp2aanSOKXkz54WNRgj/kT3gLIuTGnATE2nLVD/++13zTUMMkM7QKyEYKs0l4Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OigTqese; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OigTqese"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-55f1102b300so38039a12.2
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 17:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706490026; x=1707094826; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sUl32XdnagElZC/GjdZNn8oS0p+2WjUorr6tDLMCHP4=;
        b=OigTqeseAW2CIy6Me+bfySidSRXFp9f+4/jDeM6qsR1w4P61zChgRnYMSgbkTzJn57
         SDV9rpcz4LFWHTVwGg9pqvc7jDPi69eDk872GaHbGI+teXF5oIf/Xb1c7YBDUP8rDbHP
         TLnjgMywGRGtCyGOrT5YB+qFvvsMOzkS70XeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706490026; x=1707094826;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sUl32XdnagElZC/GjdZNn8oS0p+2WjUorr6tDLMCHP4=;
        b=LF3YHH1vXaeDpSu0bDea82Hb/mregPSOsf/FeRNPmBCMfv3xeOWc2ANASLF96GDw8M
         eLW3+9krM6tq/wTbrEjldxvtSk4JOK0IFLAEBKcDXdLkeeOpg//EEfSBV0oIvJ9hMt9D
         5b81Ary53i9L5M6+rCSVbgEXZ3NjxT2kh9JXsfB573lI7DthdRr0RJewHr8Osny633Zz
         tsrAjuZ13jZ/V6AMHqQ+WfDawdNqM+RHrLkqzcYr7zn7kj6tTvtj+Ph5P0GY8WNw0N8m
         FmnNQ8htjWnPkGpLOCSPKCdGGghVKB5e6UvvrzdmR2L+kZRSwTErcn1WTneYr2AtAHL8
         /N0w==
X-Gm-Message-State: AOJu0Yyq1ws8n0pbAIZU7dq+TwwGB3dT2KJ5HcZdva8+8uWfylyNvfbB
	y/eBHCkuqHzw9160nr4GYhtdbq+KMxA6WdXGDIUfNTroF63//XjdwT796r3sBAfmqbL7dQBEG8Z
	LWrQ=
X-Google-Smtp-Source: AGHT+IFdE+xkQOr1jfhaqzvrqaVs1+HeCHk8rnoJmxK/+mDHNVQH8o9HeHotHAcB9l9cEJQ9byHRLA==
X-Received: by 2002:a17:906:e53:b0:a31:1b72:9efd with SMTP id q19-20020a1709060e5300b00a311b729efdmr3375636eji.66.1706490026573;
        Sun, 28 Jan 2024 17:00:26 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id wn9-20020a170907068900b00a2c869c2fe8sm3337468ejb.161.2024.01.28.17.00.25
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 17:00:25 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-55ef0465507so695151a12.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 17:00:25 -0800 (PST)
X-Received: by 2002:aa7:d7da:0:b0:55d:333c:1ae with SMTP id
 e26-20020aa7d7da000000b0055d333c01aemr2876130eds.15.1706490025336; Sun, 28
 Jan 2024 17:00:25 -0800 (PST)
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
 <20240128175111.69f8b973@rorschach.local.home> <CAHk-=wjHc48QSGWtgBekej7F+Ln3b0j1tStcqyEf3S-Pj_MHHw@mail.gmail.com>
 <20240128185943.6920388b@rorschach.local.home> <20240128192108.6875ecf4@rorschach.local.home>
In-Reply-To: <20240128192108.6875ecf4@rorschach.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 17:00:08 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg7tML8L+27j=7fh8Etk4Wvo0Ay3mS5U7JOTEGxjy1viA@mail.gmail.com>
Message-ID: <CAHk-=wg7tML8L+27j=7fh8Etk4Wvo0Ay3mS5U7JOTEGxjy1viA@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 16:21, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> >
> > Wouldn't it be bad if the dentry hung around after the rmdir. You don't
> > want to be able to access files after rmdir has finished.

Steven, I already told you that that is NORMAL.

This is how UNIX filesystems work. Try this:

   mkdir dummy
   cd dummy
   echo "Hello" > hello
   ( sleep 10; cat ) < hello &
   rm hello
   cd ..
   rmdir dummy

and guess what? It will print "hello" after that file has been
removed, and the whole directory is gone.

YOU NEED TO DEAL WITH THIS.

> And thinking about this more, this is one thing that is different with
> eventfs than a normal file system. The rmdir in most cases where
> directories are deleted in eventfs will fail if there's any open files
> within it.

No.

Stop thinking that eventfs is special. It's not.

You need to deal with the realities of having made a filesystem. And
one of those realities is that you don't control the dentries, and you
can't randomly cache dentry state and then do things behind the VFS
layer's back.

So remove that broken function. Really.  You did a filesystem, and
that means that you had better play by the VFS rules.

End of discussion.

Now, you can then make your own "read" and "lookup" etc functions say
"if the backing store data has been marked dead, I'll not do this".
That's *YOUR* data structures, and that's your choice.

But you need to STOP thinking you can play games with dentries.  And
you need to stop making up BS arguments for why  you should be able
to.

So if you are thinking of a "Here's how to do a virtual filesystem"
talk, I would suggest you start with one single word: "Don't".

I'm convinced that we have made it much too easy to do a half-arsed
virtual filesystem. And eventfs is way beyond half-arsed.

It's now gone from half-arsed to "I told you how to do this right, and
you are still arguing". That makes it full-arsed.

So just stop the arsing around, and just get rid of those _broken_ dentry games.

               Linus
