Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C2249E3
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 22:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706309347; cv=none; b=fCmpy2VyZ69rLrUl/rkAW3d7id0CF7CygaDTmORSGKvSNClU7meAChuBFp5FKqk8le1Avx32BpA8bFbzsJeS1bh9T+awPBxO7jXAXPyhweQY+rsZVuelemgAuo0YdeuKRhXv2FtbyWjbHQ0L1NfodVKTXietFC3l5VP/yAgsGQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706309347; c=relaxed/simple;
	bh=ZC8lIw6nkj5AkxyuI4xf/CiVElrJVya/QfDBrLgEqn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AoVRQies9nDKt/jzFu0AFrFXjeSXdtWfPt6ScZsKM+JHvXs3UiLjuuKXbXMCyiLa314qCfnWEoFYVvDoj3Rm4aTvQ09v0dl6UuIThIkSxJlGhzXJ9MIwsQYlrV/OsCdNTW1eBIf7il6D229L+nnHfL6WpQCFS3FwPjBlhYZ7HUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MScHVDiX; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MScHVDiX"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a298accc440so133055666b.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:49:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706309343; x=1706914143; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xrhM++a5OFTukQjh6bVd0EodL17OqMY2SHvdwAgkV3I=;
        b=MScHVDiXM6oJ5JNU8P5D4csBM5lGEIPpPeJmXOcjVXbk+A/RrE7R9PFN9l8tR9Vx4B
         HVZFCO0Ui/Rf8VDrgg0Do+wsmppw6CtG0caw9sUdZwk8aQ4uoo3CxTxcGi/+1YEM7nK1
         Yjnpl1WWTrNMga7ZlyQPDjV0f7wiP0mJhMpAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706309343; x=1706914143;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xrhM++a5OFTukQjh6bVd0EodL17OqMY2SHvdwAgkV3I=;
        b=GUU1m3cIiy0Cv9Zq/Io41ylhq83HWX9pJvzSQjDe7MnhvC7cTlyY+S+SNQhseOGWDl
         pxAeOUIQBRdy6WsyJB4JpE7Atw9kT2ABZm2zAuLS/M2j8y6gnMRep6FZJ3SoxjHI/kfp
         UXCvq2ZtPIr5dlkJV/7wGs4kERAX3nFMJxSC8rEB4RGaFF5vo+/YJgjtUlZgnlQHWJDE
         /DoKQyS965Yi4UoZv+HdmEmp2yc/bB8C/xZ8gQqZ7T01YUljwSG1ztwl/oHaA2Eb2TnT
         Ekv1QNgWN0HFuKjyTdqICwgsvTgNfRuwf2iXgdyVbb3wbR9wivjSORVd+x30QiViYRAl
         afkQ==
X-Gm-Message-State: AOJu0YwvJwZwOzpBS9idZsO/W6HYUt6oP4+wcsMiWJEb38ceWTC2xsRX
	XOw//IKiorWu5Khcmd5qutX1h0a43lmRwTchR4tC6L68badGQAbg/H155PKlw8raJa/Rbt1HEG2
	/oHNxmg==
X-Google-Smtp-Source: AGHT+IHFn/AdqmPRy3X6Xv8wPTR4YUfGYaWMGyr7cIEW24OynLUzf4x9XVuGV51CocOfoMFp7225ow==
X-Received: by 2002:a17:906:848:b0:a2c:b5a1:f8 with SMTP id f8-20020a170906084800b00a2cb5a100f8mr409867ejd.37.1706309343101;
        Fri, 26 Jan 2024 14:49:03 -0800 (PST)
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com. [209.85.208.52])
        by smtp.gmail.com with ESMTPSA id o18-20020a1709061b1200b00a2e7d1b6042sm1074898ejg.196.2024.01.26.14.49.02
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 14:49:02 -0800 (PST)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55a45a453eeso1674963a12.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:49:02 -0800 (PST)
X-Received: by 2002:a05:6402:2709:b0:55d:31f8:920a with SMTP id
 y9-20020a056402270900b0055d31f8920amr513622edd.27.1706309342198; Fri, 26 Jan
 2024 14:49:02 -0800 (PST)
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
In-Reply-To: <ZbQzXfqA5vK5JXZS@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 14:48:45 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiF0ATuuxJhwgm707izS=5q4xBUSh+06U2VwFEJj0FNRw@mail.gmail.com>
Message-ID: <CAHk-=wiF0ATuuxJhwgm707izS=5q4xBUSh+06U2VwFEJj0FNRw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Matthew Wilcox <willy@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Steven Rostedt <rostedt@goodmis.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 14:34, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Fri, Jan 26, 2024 at 05:14:12PM -0500, Mathieu Desnoyers wrote:
> > I would suggest this straightforward solution to this:
> >
> > a) define a EVENTFS_MAX_INODES (e.g. 4096 * 8),
> >
> > b) keep track of inode allocation in a bitmap (within a single page),
> >
> > c) disallow allocating more than "EVENTFS_MAX_INODES" in eventfs.
>
> ... reinventing the IDA?

Guysm, this is a random number that is *so* interesting that I
seriously think we shouldn't have it at all.

End result: nobody should care. Even the general VFS layer doesn't care.

It literally avoids inode number zero, not because it would be a bad
inode number, but simply because of some random historical oddity.

In fact, I don't think we even have a reason for it. We have a commit
2adc376c5519 ("vfs: avoid creation of inode number 0 in get_next_ino")
and that one calls out glibc for not deleting them. That makes no
sense to me, but whatever.

But note how the generic function does *not* try to make them unique,
for example. They are just "unique enough".

The generic function *does* care about being scalable in an SMP
environment. To a disturbing degree. Oh well.

                Linus
