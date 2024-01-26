Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4F3224C2
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 20:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706300728; cv=none; b=jPNxo3EW49r/DI93ohQ0Rqh/YqzbWkqRQ0KE/rMnHuSDKvIQyN4ltzuVuDYBLXo99P/CtqeRBffAndswhvjAgVKgfq92pWUpYp18viYcnc+BcTDVTO3rTDHz5jmAchpAPY168p1T7cpdEm4bDvjn70y0SAcWvul3MW8CciRqyY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706300728; c=relaxed/simple;
	bh=9+OPO3V3SP3LRuHvDOl2Rmxreo2UCuuZVrw9wtlT3Qg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TxtdPmdHJ6mbEuEnxHX75HzmtjURd7hwLtzb0LwkTuPe6+46Puv9jSUleoNPt8DQ/ascVPIrNp4I7Ey3MtNf7KzwUBz3axQtT1kYrIUzxdFYCxVcFkgOCBE8d1j2DOuS/wCh1oL2EdrCU4Q2rCDeY9ZwiWWtg5FoPRI7q9bHT30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QPj29jFc; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QPj29jFc"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ccec119587so9484301fa.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 12:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706300724; x=1706905524; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ANDDmreLZfT1WX/HwjJ1bWT4NTPKcyNOAiea0NIAPr0=;
        b=QPj29jFcpalD29ebe+l7fwI6zsx6iWZyr4exXNH81BalNz4gryHcwEhChrhniGdzGp
         qehZOWrGmpLXa/0STQwdHHZXqD81XWusm2Q49xTBhnuAQRQJH29VLBgGpTIQPeHpE4RJ
         Jou1Q0Q99N9Nz/ByRY+91VA9z51AI9VZ9cChs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706300724; x=1706905524;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANDDmreLZfT1WX/HwjJ1bWT4NTPKcyNOAiea0NIAPr0=;
        b=Qvyu2HBv+g9xBKgiIhuYaVdPE+GGzJiy5eCPgZf0eaY93k5Rgua9n9fZuBjhhaJyNK
         rploty2ITnryxxFI0ILprRpNySXU+Qp7O7ICGDX4xAxFMkbdHPJeJ2QGFdLzAcAOBpBM
         eBxlmGo1afqSf5NGgWD7+oB8y1broiEpCAbw8kNYabykJ2cOSaD+ZFJ/QRV4t9GFVrYf
         jjCXD9Hf0Z1HlO9jd2KWFq1nRiPo/XJMSrHqW1dmqBcYanfrdUJ4xqd+H6+D30GVywLC
         Vli2KXji5McPwn3O6o+GPuNiMcmzz9GFpdK42ZRv1VSRy1u48ciRMMw4zBc3zaIIcRuA
         6XXA==
X-Gm-Message-State: AOJu0YycLw91P4mkuezhrLcBOUv5BBcSZD3hDPl2tZheAE2udf6+q4Lu
	85e4EzI+FDSht8lMuYJ1/dyk3ud1AZVVYOMqnOLiKL0JW6CC9wXqhQWvy4aFE5awlHGnYtYnRlg
	Zvd0Q5g==
X-Google-Smtp-Source: AGHT+IF1R9TAXCqwoi0YNFZmdTk8TFxLqCUOhln7O9IGTqCpMguJN/szG7yC1RVAwEpGOqmZY9HQVw==
X-Received: by 2002:a2e:7009:0:b0:2cd:1366:4aa9 with SMTP id l9-20020a2e7009000000b002cd13664aa9mr408454ljc.25.1706300723775;
        Fri, 26 Jan 2024 12:25:23 -0800 (PST)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id bi32-20020a05651c232000b002cf1c5ec8c5sm256591ljb.50.2024.01.26.12.25.22
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 12:25:22 -0800 (PST)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cddb2c2b54so7609471fa.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 12:25:22 -0800 (PST)
X-Received: by 2002:a05:651c:107b:b0:2cf:4170:d181 with SMTP id
 y27-20020a05651c107b00b002cf4170d181mr392047ljm.7.1706300722280; Fri, 26 Jan
 2024 12:25:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home>
In-Reply-To: <20240126150209.367ff402@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 12:25:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
Message-ID: <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Steven,
 stop making things more complicated than they need to be.

And dammit, STOP COPYING VFS LAYER FUNCTIONS.

It was a bad idea last time, it's a horribly bad idea this time too.

I'm not taking this kind of crap.

The whole "get_next_ino()" should be "atomic64_add_return()". End of story.

You arent' special. If the VFS functions don't work for you, you don't
use them, but dammit, you also don't then steal them without
understanding what they do, and why they were necessary.

The reason get_next_ino() is critical is because it's used by things
like pipes and sockets etc that get created at high rates, the the
inode numbers most definitely do not get cached.

You copied that function without understanding why it does what it
does, and as a result your code IS GARBAGE.

AGAIN.

Honestly, kill this thing with fire. It was a bad idea. I'm putting my
foot down, and you are *NOT* doing unique regular file inode numbers
uintil somebody points to a real problem.

Because this whole "I make up problems, and then I write overly
complicated crap code to solve them" has to stop,.

No more. This stops here.

I don't want to see a single eventfs patch that doesn't have a real
bug report associated with it. And the next time I see you copying VFS
functions (or any other core functions) without udnerstanding what the
f*ck they do, and why they do it, I'm going to put you in my
spam-filter for a week.

I'm done. I'm really *really* tired of having to look at eventfs garbage.

              Linus
