Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 259D04595E
	for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 22:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706309388; cv=none; b=hhC6bcHKOehWo/rdh6aB1zpIZSx3QmsHw3pbEpLwRdF0A+uidAWgLnLKKf77L+GVa/dQJ1FsmZ4rMalzxC6NE/3lWhk7ZH3u/NYc//kS7/qif7/iKM+yxZBpjW1Vgg9DHIyfbc8CBeSf2PiqLh50c4Mz7HFOxHHzWLlklnJ4/wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706309388; c=relaxed/simple;
	bh=nrNcgKqKEthh661LXbilbwqQcwL+DlDRnFwg8jZPBIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwccDC9L9pArGIdcIWjlATxGm23qxNrKJQoI4NxMV3csTILygdZkvwz8wH2nIeSP2byw8yvDdYfMZWjXaday/cxrmKxyRehs5J/OKyL2JypOAWWzXIyNuOqe9JUnah3N9OzihjNAqEjqwQ6YuJmMDPozsIKNUe8xw0PCHMguWZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Elzshj3+; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Elzshj3+"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-55c2cf644f3so587645a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1706309385; x=1706914185; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mat57ocNjJ+2j0yfyUONN2djrK+fYcTcdMIfJXsJdeg=;
        b=Elzshj3+mtNXeaGiELhCIsZspMlq+JNzAmO+Dx8bMiTivsU5WSyxufsX0a2Hr9q7Bs
         mlV9MXE8vVm1B9TUQ4B3/2q8jGKUmF6ttTAmnT+LCFecEFpJuKsuYCWvIT9o+6peeK7m
         1fP1+kBrNncMRFRdDgA7sVxjjxcXbcHX2bs18=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706309385; x=1706914185;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mat57ocNjJ+2j0yfyUONN2djrK+fYcTcdMIfJXsJdeg=;
        b=U520w3Gw5nrSgW9mkU+b3A9HAWeUBmYA+b10IFoe2dVnHEABx6iHR9sP9EWSrpwOg8
         BUdlK486IRvxEbfuOjnssfYgiX2D8D06MW1kp63rz439u5qz3Hi+JOGDa+aaPzFMcIdH
         eIsD+ge/7JMMCA0tm59o+BcnujMdA5H+atAn13RTxqjeSu3Dq0kGxfM+PrAb1ITNDSY7
         dBXge44ZfXvZNNiIBOrBmSfo/qk2c8IRxdC0bq4duGMeVPUKwuxUyoz2rMxaP+3jtZB7
         9OYFv+wDvPfUdimNExFuN8+4oHy35Fi3AG2rzxJh0tbC+WM/2JxesvWQlKxEUdU+yhjT
         7zgQ==
X-Gm-Message-State: AOJu0YzqtV2yu0omb1FKqbrFYq7TT/MQUEevuudFzswssE0BBBenB+OM
	SR+k7IvfH3j3/GusAq54dNDZO9bsHoxcFAcXgXPWOBHBD8+rBzqCRNJi/RcOraM03kdE7BAEUfh
	bRSaSLA==
X-Google-Smtp-Source: AGHT+IGYuhB6MooefIHScwAEHuwL1T30yhSdxKmil/NmaLB5crVgfGrs/WglRA0Ynrgn9lNIfgjYOA==
X-Received: by 2002:a05:6402:3482:b0:55e:7e8a:195d with SMTP id v2-20020a056402348200b0055e7e8a195dmr307061edc.5.1706309385118;
        Fri, 26 Jan 2024 14:49:45 -0800 (PST)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id 15-20020a0564021f4f00b0055c60ba9640sm1054864edz.77.2024.01.26.14.49.44
        for <linux-trace-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jan 2024 14:49:44 -0800 (PST)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-55c2cf644f3so587634a12.1
        for <linux-trace-devel@vger.kernel.org>; Fri, 26 Jan 2024 14:49:44 -0800 (PST)
X-Received: by 2002:a05:6402:b51:b0:55d:37ed:c0f0 with SMTP id
 bx17-20020a0564020b5100b0055d37edc0f0mr256645edb.2.1706309384299; Fri, 26 Jan
 2024 14:49:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240126150209.367ff402@gandalf.local.home> <CAHk-=wgZEHwFRgp2Q8_-OtpCtobbuFPBmPTZ68qN3MitU-ub=Q@mail.gmail.com>
 <20240126162626.31d90da9@gandalf.local.home> <CAHk-=wj8WygQNgoHerp-aKyCwFxHeyKMguQszVKyJfi-=Yfadw@mail.gmail.com>
 <CAHk-=whNfNti-mn6vhL-v-WZnn0i7ZAbwSf_wNULJeyanhPOgg@mail.gmail.com>
 <8547159a-0b28-4d75-af02-47fc450785fa@efficios.com> <CAHk-=whAG6TM6PgH0YnsRe6U=RzL+JMvCi=_f0Bhw+q_7SSZuw@mail.gmail.com>
 <29be300d-00c4-4759-b614-2523864c074b@efficios.com>
In-Reply-To: <29be300d-00c4-4759-b614-2523864c074b@efficios.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 Jan 2024 14:49:27 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjpyv+fhxzV+XEQgsC+-HaouKT7Ns8qT31jkpN_Jm84_g@mail.gmail.com>
Message-ID: <CAHk-=wjpyv+fhxzV+XEQgsC+-HaouKT7Ns8qT31jkpN_Jm84_g@mail.gmail.com>
Subject: Re: [PATCH] eventfs: Have inodes have unique inode numbers
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, 
	Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Ajay Kaher <ajay.kaher@broadcom.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Jan 2024 at 14:41, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> Yes, there is even a note about stat.st_size in inode(7) explaining
> this:

Good. Send a patch to do the same for st_ino.

             Linus
