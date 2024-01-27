Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3202E634
	for <linux-trace-devel@vger.kernel.org>; Sat, 27 Jan 2024 20:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706385708; cv=none; b=hZM6GRrEQ5STidoWobLYhPXkoNMQcwjdEPgSAOgw130mndLlcl2wblXAIEK+HH7HjUHFs+9URSLf7XlOVXchVxBAqO/ySp3swyMMUTo96WR0InlksJfiafDjmSYyUw4f8HzQ3M5U+Ok5wuuecil6K7PuFNKN2iKd5O7k5wSCwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706385708; c=relaxed/simple;
	bh=N4yM4Sx3Bo4zjchytKwAIMFmf9vDnuWdHVbRYVkfw1E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ApNkTanM3Khn3eiD3YU3jlypnuTlSr5GE6/G6xHP4SBKxE3VVDm0uyv5wvIH+WVXN4IvXwDiefxvmQI7+GU66VhQGpisjz8PW44hc36pN9/JR1fy0BCjq62jiAp3LIQoo8clAZY4dOV6dl3q7fgtOCn93O0EP/2OhIqzvzNeIhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h/wNPzfV; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h/wNPzfV"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-510f37d673aso228622e87.0
        for <linux-trace-devel@vger.kernel.org>; Sat, 27 Jan 2024 12:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706385704; x=1706990504; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IqDQR2DUv5doyugas4NFosE1WpuO2lGhHoJ/mTvORLE=;
        b=h/wNPzfV9Q1rRDUoWVacLyh4Xt9/kpTkRIzNlMlkiSLGRVt0vsEsUuaN6xD1FtkSls
         B9ib8hlnzQ1fbar84d7k99ecyQFLM1MxE4fTCDNwp/OWCzCAvVEG2/V/QjWJsfaba1Pp
         ykv62JFHVRl6WomEqwO3TRcIDpjio6xXv3lpw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706385704; x=1706990504;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqDQR2DUv5doyugas4NFosE1WpuO2lGhHoJ/mTvORLE=;
        b=sZqTwhva0+dE/seO9W3vB9ldkMDAgYi5hGkOto8DpyvVh5EDmpmZdm0X4n7y+drfHu
         gFTRod6T3uxC8LAR+qukLdJf+ch6cA/hueAOWs5QUTvup2VUNU+hCDu2BN0DRUHLwstH
         dxUE6FGpX+xeRSSi7iykmUFfzlW6lLxqST/RSXWB5/6VmEmjI2+TwYZ1HhrRzZm20O3r
         yb6iiCwP8J6lPtRSFKUieEfBZVvjByRzrbhVaclC5b0f8G4qWesPsPw7q9iUk24qeY/d
         9XHjdIjSLZBKoXrfnx2ibfUk4ieYK3fMhVh/xM4JSJq23dtGdGtfogfAgYyD28akou+9
         irmw==
X-Gm-Message-State: AOJu0YwYmvbBlSSofCmnpmmf7vniadtMIGL7OrzMFfKLMh+JrZas3FsT
	LQadqgpv9bj6JzO0QxfAaXvF8ta4oWAXvF7KoM4twLWilONtpdrQjWMcGL5Tbl1wpaa7iJ/FZyX
	vuHze6g==
X-Google-Smtp-Source: AGHT+IGnLjX4hWyQP6dVgypAoxDAIAXmAp2DlfRYNo1ePXiR+iQonqfj+3h1jlLygYruVnmpdbsKnQ==
X-Received: by 2002:a05:6512:39ca:b0:50e:b5fc:bdcc with SMTP id k10-20020a05651239ca00b0050eb5fcbdccmr2470186lfu.63.1706385703900;
        Sat, 27 Jan 2024 12:01:43 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id rg9-20020a1709076b8900b00a354e4d3449sm746936ejc.120.2024.01.27.12.01.43
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 Jan 2024 12:01:43 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-55ed8578088so152109a12.2
        for <linux-trace-devel@vger.kernel.org>; Sat, 27 Jan 2024 12:01:43 -0800 (PST)
X-Received: by 2002:a05:6402:3137:b0:55e:b30c:e0db with SMTP id
 dd23-20020a056402313700b0055eb30ce0dbmr1269613edb.35.1706385702705; Sat, 27
 Jan 2024 12:01:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <9b34c04465ff46dba90c81b4240fbbd1@AcuMS.aculab.com>
In-Reply-To: <9b34c04465ff46dba90c81b4240fbbd1@AcuMS.aculab.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 27 Jan 2024 12:01:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgX6VV4nEpC7+f=QZq6VDrJxVJd_7vVfJdhq5aWDHM0oQ@mail.gmail.com>
Message-ID: <CAHk-=wgX6VV4nEpC7+f=QZq6VDrJxVJd_7vVfJdhq5aWDHM0oQ@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: David Laight <David.Laight@aculab.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Christian Brauner <brauner@kernel.org>, 
	Ajay Kaher <ajay.kaher@broadcom.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 27 Jan 2024 at 07:27, David Laight <David.Laight@aculab.com> wrote:
>
> Doesn't Linux support 64bit inode numbers?
> They solve the wrap problem...

Yes, but we've historically had issues with actually exposing them.

The legacy stat() code has things like this:

        tmp.st_ino = stat->ino;
        if (sizeof(tmp.st_ino) < sizeof(stat->ino) && tmp.st_ino != stat->ino)
                return -EOVERFLOW;

so if you have really old 32-bit user space, you generally do not
actually want to have 64-bit inode numbers.

This is why "get_next_ino()" returns a strictly 32-bit only inode
number. You don't want to error out on a 'fstat()' just because you're
on a big system that has been running for a long time.

Now, 'stat64' was introduced for this reason back in 2.3.34, so back
in 1999. So any half-way modern 32-bit environment doesn't have that
issue, and maybe it's time to just sunset all the old stat() calls.

Of course, the *really* old stat has a 16-bit inode number. Search for
__old_kernel_stat to still see that. That's more of a curiosity than
anything else.

          Linus
