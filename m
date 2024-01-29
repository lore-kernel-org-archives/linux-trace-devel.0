Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D430BDDC6
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 01:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706492572; cv=none; b=qpjkjBhmcZbObIUt8rPd7iTEuWNuf8WPlrnsg2V442COvhf+POnjRmemZWVep8vDA2P4VMJa3VobEwyUmrVTUazDL/hENxGBuyVXf78X1Y3427gp2QUuov7SPkNwCwRfd3tqYRBcbmC16HGp6XD0DCa+kefxFrh/QrQWyF2E65A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706492572; c=relaxed/simple;
	bh=jWloI5phTfFMjDxmvM5fOgnQ0vyxnALm4mf/sCbpm20=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DbIifcPzHLEtnLlx0GhsmZbCHZRRPug8M7Wv0n4OmM8AukT8gV1GJVNrC1x3kb81LAiGdEhelkh4ovuo1OhdETME6hRHiXad9E4NA7WGQhK/mQc9X9ZowNe4Yqs/q3q87xDtfy5GtXI8xMXIFqdhM0ZYkELdaiOtcwrLjaWrplo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EPoje+CC; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EPoje+CC"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-55f13b682d4so4309a12.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 17:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706492569; x=1707097369; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tmwJigiCm1y/pWMgjrvap0eEiQZ4O/kCC0i78tTYfew=;
        b=EPoje+CCAclWIpjRXfnDgG3Nz6WnRC8FZSxgmqIW8oLuvFk+EL2fhnGYmcDKWsV/u9
         j93QXlJX/RY1WivxAJHmBGl9sJpY6s9dD0nYkITI45Uv7aQUJotzdrLn9RYZQ0R9MlzE
         Yt5wBhzMZUpdxTvQLImF0fnPd/gzDtDsBwUzc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706492569; x=1707097369;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmwJigiCm1y/pWMgjrvap0eEiQZ4O/kCC0i78tTYfew=;
        b=fDGPaVZs5U9l7zAJF/l++gEOheI+CT7Lj5qlZKENk2ho5jY9Dv8Mln/Zv3EI6+uQKS
         L2DxxeYzJALi7NntPSbY9hTYczKJs7Gkl1/XiCCRWQ1Gt6O1ThFXinXdwNBna0xP28Yt
         2g5OA0QXL19bzzuNmRrb2cQOIfpUG85SR5RY2L+Tcx7RDE8lsHPlTx6YxaXYnUqdWzPn
         fvLkUOGvfO5TjBu7eNajqopQPCmE/6LUVOcGe6Njs0ozGO7Aw2G25HCf5/EMDItlUjFH
         5K+WpAWTnQSWgbjTSacTqPoBsiNaeHAG3ZGLRX0GS5bqYNo5h/wSrX2ToEHYEjsungCQ
         SKkw==
X-Gm-Message-State: AOJu0Yw1KzQ/w2w+qsrzgif9uH1VQkh7Zzsj63zkas19ZCo2eSB6MJ03
	x3hSig4ZSOyc7a0znyTz98TT9GQ/so2M0n2MYrT94W3zFSyQuuwImfwihJC/IPFJFii04yEqPK+
	Rka6Q1g==
X-Google-Smtp-Source: AGHT+IHcR1L/BPNo4erieaUXxUNxhN59cqgtWzL/6yf71WQ3aUvI37v8Cxw4FgMVTAUCITrOYsaKIA==
X-Received: by 2002:a17:906:3ca:b0:a31:7cf7:9f3a with SMTP id c10-20020a17090603ca00b00a317cf79f3amr3775393eja.43.1706492568868;
        Sun, 28 Jan 2024 17:42:48 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id ub14-20020a170907c80e00b00a3109a492d4sm3347780ejc.20.2024.01.28.17.42.47
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 17:42:47 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-55a45a453eeso3079116a12.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 17:42:47 -0800 (PST)
X-Received: by 2002:aa7:c70f:0:b0:55e:c2d9:3750 with SMTP id
 i15-20020aa7c70f000000b0055ec2d93750mr2555420edq.5.1706492567478; Sun, 28 Jan
 2024 17:42:47 -0800 (PST)
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
 <CAHk-=wg7tML8L+27j=7fh8Etk4Wvo0Ay3mS5U7JOTEGxjy1viA@mail.gmail.com>
In-Reply-To: <CAHk-=wg7tML8L+27j=7fh8Etk4Wvo0Ay3mS5U7JOTEGxjy1viA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 17:42:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjKagcAh5rHuNPMqp9hH18APjF4jW7LQ06pNQwZ1Qp0Eg@mail.gmail.com>
Message-ID: <CAHk-=wjKagcAh5rHuNPMqp9hH18APjF4jW7LQ06pNQwZ1Qp0Eg@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 17:00, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>    mkdir dummy
>    cd dummy
>    echo "Hello" > hello
>    ( sleep 10; cat ) < hello &
>    rm hello
>    cd ..
>    rmdir dummy

Note that it's worth repeating that simple_recursive_removal()
wouldn't change any of the above. It only unhashes things and makes
them *look* gone, doing things like clearing i_nlink etc.

But those VFS data structures would still exist, and the files that
had them open would still continue to be open.

So if you thought that simple_recursive_removal() would make the above
kind of thing not able to happen, and that eventfs wouldn't have to
deal with dentries that point to event_inodes that are dead, you were
always wrong.

simple_recursive_removal() is mostly just lipstick on a pig. It does
cause the cached dentries that have no active use be removed earlier,
so it has that "memory pressure" kind of effect, but it has no real
fundamental semantic effect.

Of course, for a filesystem where the dentry tree *is* the underlying
data (ie the 'tmpfs' kind, but also things like debugfs or ipathfs,
for example), then things are different.

There the dentries are the primary thing, and not just a cache in
front of the backing store.

But you didn't want that, and those days are long gone as far as
tracefs is concerned.

              Linus
