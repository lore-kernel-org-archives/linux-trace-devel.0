Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0C0724A1B
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 21:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706305001; cv=none; b=A83E58l9SBjMxuJU5WjXK0hRAp1LuJ16Y+r0jPX0MwFrkKp/gFbnlgL4YDb1ytDp4H74jpPE6lzpmRFuVGNc3oNGt8+KYt2ZuX7+4LdObacmmkvrSmu8ih51LwxeEuQe5Dm1mWcWPbik8nd+HzkClOFNDZa4WVxzKJs8h/5mx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706305001; c=relaxed/simple;
	bh=YfaSbj7aWucYRD8fpKinICpQCEEwoP2iLjQO/Z3wcuU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lvw9XwT+BbNlzloF6QG5a2wgeqcUS4cWIkjUoti2aKqPBH7CHl8koCsjd4M5YgQeeCWIHVHWEmgHu6n+yhJJu2UP36GQV/G5vqtTMGGmq9AwlasM5DZeW/83hYkYeEVMBCsWw5G7hs91+WCdWwJaxq43G825ODgB4XY/EIX602M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iKkZLDSW; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iKkZLDSW"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5100ed2b33dso1705996e87.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706304997; x=1706909797; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CvqA4oK/Qg0raxZ+27W7q7BWtiVAxq8zsa6fXWM1cKw=;
        b=iKkZLDSW+6hp07wNnKL6tXBFlxzbgBO3yJRlxOxG5YhwmPItJEtCKFD5Fv+sWSRmYX
         v2pX4ev7Kn+tw5U0g/Au9rHC5LAQeSl+MPtv7n0uaEscNmsr/HVyRJ6dflxqOksvQodG
         Lxg5BQeNkG5YunfSlbOj9OM8087S/GYvo9RBg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706304997; x=1706909797;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvqA4oK/Qg0raxZ+27W7q7BWtiVAxq8zsa6fXWM1cKw=;
        b=SDVPxlnbuyNAyqzCIIV5SZta1Z9yUVsFOBnYdTiAHU98I6OCBVTMYdHX0p/kfIk14e
         1kdfDxPYLHkUb4TzUSnGCHRm1R1dtm1u+M4k2RmyNQw2Q3QxH7gJWJF/AlUJT2cXkKvg
         XjcpB9MKr2DMAzXDt/2jaK+52wrN0e4UF1LZ6/uLQXSuZSSRGBhD2gz75/tPdhTwsGAg
         9gEXTy7XAO4nhyQnUL66kJxdauEVzM9ROdLsSCdJYCBIa0hrMh1BH4DjDpX7h9+u81r7
         b6S/DJryvbrcnZYhT+lMVKzj0kI8dfuMPRUzpA2o+cEaeSDTacImxHY7TYJuXA6/hg5Z
         WBLA==
X-Gm-Message-State: AOJu0YwHnOHVD3vQHhaoklkkwv6juFz2TVxzN3zaw4u8dzcD+RbYtdVW
	kLZ+WkTzJnbOz6b/Hrc0rZZGi+ES40OtXVnGcd5AxYdDAk9agXYE/h6gylEQyaofYQMn7Zmi/NR
	/07EndQ==
X-Google-Smtp-Source: AGHT+IE9BDLPFR34ZuQ+JReDE6Xx5P/cnhM44nZ8Z/EBGUzRzXYEGRLYf7XtnNvbC6ctpD5HW/878Q==
X-Received: by 2002:a2e:b1c7:0:b0:2cd:9959:53a5 with SMTP id e7-20020a2eb1c7000000b002cd995953a5mr243394lja.10.1706304997389;
        Fri, 26 Jan 2024 13:36:37 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id e10-20020a50ec8a000000b0055c643f4f8asm1004439edr.32.2024.01.26.13.36.36
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 13:36:37 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-55c2c90c67dso576685a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 13:36:36 -0800 (PST)
X-Received: by 2002:a05:6402:1656:b0:55d:4375:cd14 with SMTP id
 s22-20020a056402165600b0055d4375cd14mr223875edx.26.1706304996651; Fri, 26 Jan
 2024 13:36:36 -0800 (PST)
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
Date: Fri, 26 Jan 2024 13:36:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
Message-ID: <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
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
> I'd be happy to change that patch to what I originally did before deciding
> to copy get_next_ino():
>
> unsigned int tracefs_get_next_ino(int files)
> {
>         static atomic_t next_inode;
>         unsigned int res;
>
>         do {
>                 res = atomic_add_return(files + 1, &next_inode);
>
>                 /* Check for overflow */
>         } while (unlikely(res < files + 1));
>
>         return res - files;

Still entirely pointless.

If you have more than 4 billion inodes, something is really really wrong.

So why is it ten lines instead of one?

Dammit, this is a number that NOBODY HAS SHOWN IS EVEN WORTH EXISTING
IN THE FIRST PLACE.

So no. I'm not taking this. End of discussion. My point stands: I want
this filesystem *stabilized*, and in s sane format.

Look to *simplify* things. Send me patches that *remove* complexity,
not add new complexity that you have zero evidence is worth it.

Face it, eventfs isn't some kind of "real filesystem". It shouldn't
even attempt to look like one.

If somebody goes "I want to tar this thiing up", you should laugh in
their face and call them names, not say "sure, let me whip up a
50-line patch to make this fragile thing even more complex".

            Linus
