Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E533090
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 23:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706310736; cv=none; b=MO+23Hn/2MWtxPfI44qhV5T1ZOpa06DrEWXm9PQlTBrNcxmm6t9BuzIgFmxKbz3SWSfWU8oVPftyB2cBoFY9nzoq8+KG8vB8ZUgbeHM4THKWKsyWNTBo/Q/eHRxv7nrs/QcRXVW876JzlwOg9aRQlGrUS9c2otJcNq8PqNLC6J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706310736; c=relaxed/simple;
	bh=2P1MSft8X93++r9/w92I/KK2xvEAgYJknw4bsWY3hGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F31wvBwTtSvS8Z2HWN6sbQiSPpoge8QKpW8nJTey31cER+GAQnt+kfpN6T1xHOT+EPSHrn6B1GBSTxjKEUabtPM+yyOQwrek4YSM+crmHK5zSWJIN6dFSxHHKrqyApcbeL2qC9T+RisqfHybDoLBzetR1YDeg1V/E26j6X3nxoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gD5yQV2M; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gD5yQV2M"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-40ea5653f6bso16232235e9.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 15:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706310733; x=1706915533; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bdf20BJ6O42hFp/1Syn6ytLGURr08JkqxpxmJ3QroSs=;
        b=gD5yQV2Mc822Z8tzP+epYsC1S83NUsNBcuMoVKAw0TwfmXrAO9R6K3KlPk4F8Py4/0
         XlgGS3bHaVcg/3skM+hjVcpfvIIyK0LFOiVfNaiX9t9V0vvKUyuB63tEyddLUhuc4pMb
         +znmwpDrHpcQM+6gCkXklqSRijLaFqvt424ZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706310733; x=1706915533;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bdf20BJ6O42hFp/1Syn6ytLGURr08JkqxpxmJ3QroSs=;
        b=gRE0niQqciO4Ijryv5ZXc8m5jKH9R22lKCNFehP4tAM8zUp6C1k42ZGNRx2qIubknp
         Hxpcb0f7iBWH/4BSeL3WEdvqvv+W52PHshhx6ldoBpCJrRgzu5IAFN4cIpKY5qRtgY5b
         D0m6tZlLkgnzDR69iKQFxyEhGXRVrQeDGkIInzpMjIq5FN/RMjnFGgXN/iIs6LZzfCdZ
         LXbaU9WzYH/i+nC5Nskc9VFRRRn47tYrPWDFQPkrkW4CRztCZggYCpVm7oarXNhoA+3+
         oFpiMx82ZCcxysnz+V25wDGcW8rNPqTbZ7T3gxM6nw7xqsMFLtbsQW1r1Q07yD8+VRHQ
         RZKw==
X-Gm-Message-State: AOJu0YwDEg5//4GG00kNB47WYMFWAixaPc+5f2boA0edmyF5z6BXn2vs
	mvnaGvlpBrKP1LpcKdDPq/Jvy1fujIlfWDbnVT/6GFSGwQAyyp1QZeKhvO15HGYFdAO+5aXJl/3
	G5WsEew==
X-Google-Smtp-Source: AGHT+IE2RpbsrehgwuLYO7mryeC2Hu4Ar+QBg6GdJWuRK/CwVtXLfeVWkiID1TWrksRcGpPnAOG9qw==
X-Received: by 2002:a05:600c:4f02:b0:40e:bfc5:f295 with SMTP id l2-20020a05600c4f0200b0040ebfc5f295mr363111wmq.125.1706310732622;
        Fri, 26 Jan 2024 15:12:12 -0800 (PST)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id x6-20020a056402414600b0055d36e6f1a7sm908316eda.82.2024.01.26.15.12.11
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 15:12:11 -0800 (PST)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-55a3a875f7fso523618a12.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 15:12:11 -0800 (PST)
X-Received: by 2002:aa7:c3cc:0:b0:55c:f699:c393 with SMTP id
 l12-20020aa7c3cc000000b0055cf699c393mr269406edr.32.1706310731406; Fri, 26 Jan
 2024 15:12:11 -0800 (PST)
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
 <CAHk-=wiF0ATuuxJhwgm707izS=5q4xBUSh+06U2VwFEJj0FNRw@mail.gmail.com> <ZbQ6gkZ78kvbcF8A@casper.infradead.org>
In-Reply-To: <ZbQ6gkZ78kvbcF8A@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 15:11:55 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgSy9ozqC4YfySobH5vZNt9nEyAp2kGL3dW--=4OUmmfw@mail.gmail.com>
Message-ID: <CAHk-=wgSy9ozqC4YfySobH5vZNt9nEyAp2kGL3dW--=4OUmmfw@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Matthew Wilcox <willy@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Steven Rostedt <rostedt@goodmis.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 15:04, Matthew Wilcox <willy@infradead.org> wrote:
>
> Maybe we should take advantage of that historical oddity.  All files
> in eventfs have inode number 0, problem solved.

That might not be a horrible idea.

The same way "a directory with st_nlink 1 clearly cannot have a
subdirectory count" (which tools like 'find' know about), maybe it
would be a good idea to use a zero inode number for 'this file doesn't
have an inode number".

Now, presumably no tool knows that, but we could try to aim for that
being some future standard thing.

(And by "standard", I mean a practical one, not some POSIX thing. I
think POSIX just mentions "numberr of hardlinks", and then the whole
"a value of one means that we can't count subdirectories" is just a
practical reality for things like FAT).

               Linus
