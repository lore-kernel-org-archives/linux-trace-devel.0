Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005BC24B22
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 22:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706308162; cv=none; b=AV1nttyd9YvxYEJhqFq0G6gch4R7hYj9ZazT4Bf3l9jya0vBeWJXHFrSLWAvfY3vwwXTvnXMw1pcPy/e1ldbxUJkgMQ53PAFJAxENzMdxv3WyZURgDZ1zF0QhgZjlsvxRvquESYx3Eq5lWihPI1D8mYdSV9mHftvKkq8DdxHnpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706308162; c=relaxed/simple;
	bh=bnGLdwzstqH5AfSoLZdw6+SstBNNV6/ADu5DzEq61y8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Uu+ABuonPHe6/pozpix8pOArX27Z3phMFJfA0oUTSrEo10EbtmYySglEStVhVVynPjrR2yInihJ028CMar2GWdtgtxI1N53UuwShlGXFPskVKZY9r+wkskjFK4AQwD/31vo6t2gCkoa3VDM4B2Io6Js1ApdB1ECjRA0ruwZWpvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HMMmvQiZ; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HMMmvQiZ"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-336c8ab0b20so933318f8f.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706308159; x=1706912959; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=tRiurWLUnvaCNMuWmJHCRa1/X+mumAqXgtZJfgR1jGc=;
        b=HMMmvQiZpcgtqcBgmKLGP1OTAtqXFA5fFA1zn82JXWqVQdz05IFfEqaQtgeeSAdoCG
         B80fFH/6MXRB1fcioh3BmndcuHCC+zV22aIWr0b1o8zPyt2MTVBf0CvRtlOhvffp7QOF
         BPmGL2/okUnkrEyYQ0B7JKZ7I17BgPp78XZJk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706308159; x=1706912959;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tRiurWLUnvaCNMuWmJHCRa1/X+mumAqXgtZJfgR1jGc=;
        b=t3DULm9i2gaMbzvD+2LyrUA1ZG39If3T1dQ+kYfYDHN9lxtB5Nv+ZCvSF0g2DSPzQM
         99HflahwmeJ3SF60oO07u8rI6kut0tq+kksfg19z6wgzzjhyVqEyN9kg39w3qkN54Jt9
         J/cHCWU9JKpfKpjF0Fy/LPo8WoxASvkSjcXKKPgf5523jwVQRpHY+EDibSrtLt7xvwKS
         5NiTBUcrhDiA2/+Eh22fOnbKWApy3Nqm9tx5G5+yjx+dLrHhZhlbDZ3THfywrky7yREE
         cgn05I1YdE0VK/82sOjzXE58c2v/YbSKd4VQAVAdGagrJt/8nMudLJ5n8+q8qjUdgI5V
         JWWQ==
X-Gm-Message-State: AOJu0YxinqMtLvxQXFIC1bPmiRRzW73QV79A4gQ976KNTATsh8U/WlhN
	eFif9+ToMuvi1qBo4+XMpU7Zzie2hB332zQqAiNjw9q9P4VogLPgsr+2DmhlSANbfi1XhVQ5bYf
	vzqpLxw==
X-Google-Smtp-Source: AGHT+IH0yJrfHX15vG+jMJ9NcXHEXkb3tYVi+9lFzgDafQhXMyJjdkUy6er6Wm9hS8sgGRZJa15QEw==
X-Received: by 2002:a5d:5cd0:0:b0:333:3dd:6cc3 with SMTP id cg16-20020a5d5cd0000000b0033303dd6cc3mr240878wrb.21.1706308159119;
        Fri, 26 Jan 2024 14:29:19 -0800 (PST)
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com. [209.85.128.46])
        by smtp.gmail.com with ESMTPSA id rs6-20020a170907890600b00a26d20a48dasm1070154ejc.125.2024.01.26.14.29.18
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 14:29:18 -0800 (PST)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-40eeadb7151so3757215e9.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:29:18 -0800 (PST)
X-Received: by 2002:a7b:c5cc:0:b0:40e:c5fd:8ad2 with SMTP id
 n12-20020a7bc5cc000000b0040ec5fd8ad2mr348816wmk.44.1706308158118; Fri, 26 Jan
 2024 14:29:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com> <8547159a-0b28-4d75-af02-47fc450785fa@efficios.com>
In-Reply-To: <8547159a-0b28-4d75-af02-47fc450785fa@efficios.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 14:29:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=whAG6TM6PgH0YnsRe6U=RzL+JMvCi=_f0Bhw+q_7SSZuw@mail.gmail.com>
Message-ID: <CAHk-=whAG6TM6PgH0YnsRe6U=RzL+JMvCi=_f0Bhw+q_7SSZuw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 14:14, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> I do however have a concern with the approach of using the same
> inode number for various files on the same filesystem: AFAIU it
> breaks userspace ABI expectations.

Virtual filesystems have always done that in various ways.

Look at the whole discussion about the size of the file. Then look at /proc.

And honestly, eventfs needs to be simplified. It's a mess. It's less
of a mess than it used to be, but people should *NOT* think that it's
a real filesystem.

Don't use some POSIX standard as an expectation for things like /proc,
/sys or tracefs.

              Linus
