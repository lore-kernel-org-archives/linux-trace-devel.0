Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951BA250EE
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 21:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706304682; cv=none; b=TpbPZsTpU9EklM8680EtqkkSpNKsTc906tU2RT6Tty510KRb2Zzs6HVWbmrJf5ToNEfgdZUsFUhz0AUJolAURxcAM86FPVXPnZ1+r34R0Gq63SyW4CBxv6Sfmy1NvLhd3TvDTn5A7lJDunsdUy6eIlUQqpNNYRnBKqEoRI7dChg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706304682; c=relaxed/simple;
	bh=6mukGWAjPX2YjUL4JezyXFLuCN/rYL2RbG8PlJMIYCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKg1lZE0pR7x+9IzNBsWOYfnVC9aMYj6r3xgxkkpfEa5alPAOSasRM2M4LUgItIiBjcggPbWp8NN5k1xMeCIsT4oNnme1Hx+JpPluB/dCFfnrkjFGxMKn9tpSBdCRjANYXmcNKnnzYIc4alWBLIZH0T3XBvMAevMcedBglmlUxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q7ydLpfR; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q7ydLpfR"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a313b51cf1fso150339266b.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:31:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706304678; x=1706909478; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=maDpcikpyh6FEh8N/tIM7o82tGen2/tmETzOibUg/is=;
        b=Q7ydLpfRJBIPc1zDGpnWKX59E/L2MQWkHam27t3ye3pXQ8KhaHdVt0cKFF7tR4dRhW
         8FJHYZqd8atnsWngv3bauKLiWGGaYBjyXN/6BBDtmjfKU0cxI5e9ZJu7aCAHhq8d6EVd
         ERs1EzNLsVqS933T2uYBsrpwCzZJu/0QPBC+I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706304678; x=1706909478;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=maDpcikpyh6FEh8N/tIM7o82tGen2/tmETzOibUg/is=;
        b=UzLekXMQZxhwQyBd49odWPxur5Z9D+82df77/DXnN+v5ko9d5h1b3T6C7sZw86Ym/M
         1CwW31AhwOb/UlYaKjFAkaakbPr+zetQyfU8ovjlPchUbS5CAqkCutiRJFlx9H/P6sB2
         +qqaoILh1rCYq+CHJ4s1KJTBAdkId3gGwwzko/FuSyOtPa/21Rt/f9d2uGqAcPp0cM6z
         qKfeem6V2AucULvI5P+LtT0GL3uUx5eJOKEFkRzFtdurt9EKZ/NuiyAm1hB7gbETe7KC
         MG+u/IDt7EwhliUWpFwrB6tykOdlwe21Q3Grm8WLI2WYblB2xs5XvodnUxqGFftF+XzW
         4HHQ==
X-Gm-Message-State: AOJu0YzeWnNYRLAVHtngpy9/WDR1bV1qHUNChnXnix/EBWqaZ/f8VtdL
	uA+zr/VcxhyHhtbkbBv5Ss9NvSCEbaEL4SJJs2Zl6PQFaXy0txPrxdH7pHj6E49gm2wi65z8+D2
	mrExiXQ==
X-Google-Smtp-Source: AGHT+IGEbf48o8LDh2t0hE6PeIIqNviuHHkLA4G5JSRpo7OG3fKaF9NurBDNbKdzJMNS7nAQqSWkJQ==
X-Received: by 2002:a17:906:f106:b0:a34:a178:5acf with SMTP id gv6-20020a170906f10600b00a34a1785acfmr884588ejb.16.1706304678699;
        Fri, 26 Jan 2024 13:31:18 -0800 (PST)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com. [209.85.218.45])
        by smtp.gmail.com with ESMTPSA id l13-20020a170906078d00b00a3221de5a82sm1043102ejc.179.2024.01.26.13.31.17
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 13:31:17 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a2d7e2e7fe0so165036166b.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:31:17 -0800 (PST)
X-Received: by 2002:a17:907:75cd:b0:a30:e9a6:68f6 with SMTP id
 jl13-20020a17090775cd00b00a30e9a668f6mr2088169ejc.37.1706304677484; Fri, 26
 Jan 2024 13:31:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home>
In-Reply-To: <20240126162626.31d90da9@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 13:31:01 -0800
X-Gmail-Original-Message-ID: <CAHk-=witahEb8eXvRHGUGDQPj5u0uTBW+W=AwznWRf3=9GhzxQ@mail.gmail.com>
Message-ID: <CAHk-=witahEb8eXvRHGUGDQPj5u0uTBW+W=AwznWRf3=9GhzxQ@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 13:26, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> So we keep the same inode number until something breaks with it, even
> though, using unique ones is not that complicated?

Using unique ones for directories was a trivial cleanup.

The file case is clearly different. I thought it would be the same
trivial one-liner, but nope.

When you have to add 30 lines of code just to get unique inode numbers
that nobody has shown any interest in, it's 30 lines too much.

And when it happens in a filesystem that has a history of copying code
from the VFS layer and having nasty bugs, it's *definitely* too much.

Simplify. If you can clean things up and we have a few release of
not-horrendous-bugs every other day, I may change my mind.

As it is, I feel like I have to waste my time checking all your
patches, and I'm saying "it's not worth it".

               Linus
