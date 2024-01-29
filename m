Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7C17991
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 04:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706500902; cv=none; b=hScTkHZSwW3Bo5ExmCcyK/i1UpSAnOXz+iRKYcY7DmGL26tyLXU69GG+HH1bvvNajTS8cRxr2d+7NgSsFBTefrCJ7+UtqNbhFeLCdEbFJqbYvSAxFsPJGRf0IRNWD4M/FiZ3Dk+Q3U4jLj2tnkJNojmMxSANBOyfd7yNnIfZgTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706500902; c=relaxed/simple;
	bh=xkL43O7OU7ppcLkBh7OlkPsjLq6ZFYIqsGEUJU4E5HM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RNAZsjUWMUIu9Al57/U6YHi8cLXya5CaEU9taIMS9/WdB0vDigasQjbsu909ChMyb9Pp/epJaK29tdQ5JmRYy4kjuUVGFhaF77AHNk7tLWBUe+r/qJ75mT0r9wZvJBDBOrGYNO5PxfeEi1C09HSSkTWzjMhoD9/b2q/2CdfOPH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VqkPGPVk; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VqkPGPVk"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2cf328885b4so24838611fa.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 20:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706500898; x=1707105698; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n3rcnUVyGJZKxOB2+kTh5T1A/eFH+JMPmm6YXhef9ps=;
        b=VqkPGPVkhy8EqpLeBANqz3+Rc7n0CByyEgJsKoo8153BBLEAGDwL606nmXm+QM7f1q
         zWOt8Q3VKDgCxiRKmubYLiBxf4viwUfHNJMnZKyyECCDSTgImpqxBxT1uNAaokReumTn
         QYW9IxrSLXDVLo3tDb7+/N+6uNimjKA7YOngA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706500898; x=1707105698;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3rcnUVyGJZKxOB2+kTh5T1A/eFH+JMPmm6YXhef9ps=;
        b=sHQHm6Qo/tYtlEJu5bkyHZt6ZSF5meXy+GsfcQG/rMjYRdxy0b7OYVDip+PNHL4D3A
         rv18KzOgZNW6MBJ55pH4N8EEI2pJT/uQi6E4i5DZ/3eyBju9czCfaNvLYyV2Kqwz6J7l
         /inVyW2/L3WDT0TY3XuC14nL14tTR+ZPMyFeEO1ripjdS9JUT0MUcTLiR7mpzqFEfDKS
         Yvm2GDjtJk4ivWzbsxBrxsGp/JlXIbP8O7fcHwSO6ooG/4A5RdhXiV8j8cKxjLNGIxNB
         4+dBJSJ92X4iacUs/MlrW6jpCZOlffZ1KIt87/QtEvgUcvYwWQPCZlJWj4e0FnN/UPFs
         v7BA==
X-Gm-Message-State: AOJu0YwynKtwE1lX7h6lpXKu3b84y/k8pTqwU0O9s/ywk+j/jDMF+CD6
	56q0FW1qKLzR8lqe3ynSe5vNHffz5v251lKH8M91l0HJmqmfT1uLKcUGnOJShEWOEeBKTpyX2yu
	NYaRMvg==
X-Google-Smtp-Source: AGHT+IEb7WbeIoyiT7fdulTKV4+xAI4HGI2ynl8DgM9MV+/pUgAfR++8tWhUvj8oFDrUChkpQpJ7Ew==
X-Received: by 2002:a2e:b1c5:0:b0:2ce:dfc:db78 with SMTP id e5-20020a2eb1c5000000b002ce0dfcdb78mr2995326lja.29.1706500898659;
        Sun, 28 Jan 2024 20:01:38 -0800 (PST)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com. [209.85.167.49])
        by smtp.gmail.com with ESMTPSA id p17-20020a2e9a91000000b002cf114820dasm1019411lji.124.2024.01.28.20.01.37
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jan 2024 20:01:37 -0800 (PST)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-51028acdcf0so2622162e87.0
        for <linux-trace-devel@vger.kernel.org>; Sun, 28 Jan 2024 20:01:37 -0800 (PST)
X-Received: by 2002:a05:6512:12d1:b0:50e:6317:54ab with SMTP id
 p17-20020a05651212d100b0050e631754abmr2806079lfg.42.1706500896681; Sun, 28
 Jan 2024 20:01:36 -0800 (PST)
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
 <CAHk-=wjKagcAh5rHuNPMqp9hH18APjF4jW7LQ06pNQwZ1Qp0Eg@mail.gmail.com>
 <20240128213249.605a7ade@rorschach.local.home> <20240128224054.0df489b8@rorschach.local.home>
In-Reply-To: <20240128224054.0df489b8@rorschach.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 28 Jan 2024 20:01:19 -0800
X-Gmail-Original-Message-ID: <CAHk-=whjO4zAmoP8fQkHUQJANahFMZaviNu=Jfd36E=knLPVgQ@mail.gmail.com>
Message-ID: <CAHk-=whjO4zAmoP8fQkHUQJANahFMZaviNu=Jfd36E=knLPVgQ@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, 28 Jan 2024 at 19:40, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> [  106.258400] BUG: KASAN: slab-use-after-free in tracing_open_file_tr+0x3a/0x120
> [  106.261228] Read of size 8 at addr ffff8881136f27b8 by task cat/868

Are you refcounting the pointers that you have in the dentries (and
inodes)? Like we talked about you needing to do?

Every time you assign a pointer to d_fsdata, you need to kref_get() it.

You try to work around the tracefs weaknesses by trying to clean up
the dentry data, but it's WRONG.

You should refcount the data properly, so that you don't NEED to clean it out.

               Linus
