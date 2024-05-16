Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DC72837B
	for <linux-trace-devel@vger.kernel.org>; Thu, 16 May 2024 23:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715903474; cv=none; b=o3fIlOMA1Z1tkkBaKyG39dDVe983dmkffYr4IFgXePmyXrS09gKgkmJeiBSPG+V4yY8TaoVZ6PuAsIxns9GJJJGqIq//t54L76C/62NkdPKWnPUsnJB7j7E9EE4/0Y6SvYiwU9TDLXKaAEJdP9vyAoS5Vfr9/uNAsbt5caQ87S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715903474; c=relaxed/simple;
	bh=iFhZQJZcWzhAye7aDpwjmVdkOa/20MfmQf2xgB4/U8M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pavSIJJENRJIZft68KwofaypNqbDMAzK9DmsC4hOo5uDl7vagf2UdZeLloSZPEsevQotsTOqdiP7mlhJTTAFfI7sTaFS9L365YntVz70PsNVp8fBKdQYeIwUcp9DgUEKSVxfHb8wYWUPq5ZFJDecYVWWB9vYheunoadUb1meOts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA876C113CC;
	Thu, 16 May 2024 23:51:13 +0000 (UTC)
Date: Thu, 16 May 2024 19:51:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Rogers <irogers@google.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v1] libtraceevent: Avoid a simple asprintf case
Message-ID: <20240516195110.2b91d4d9@rorschach.local.home>
In-Reply-To: <CAP-5=fUYxxmH8X0RVhdSWzKFT+WJO_UDULCtO4PK+VO-osXwGA@mail.gmail.com>
References: <20240509051317.1913001-1-irogers@google.com>
	<20240516180248.24aa5aeb@rorschach.local.home>
	<CAP-5=fUYxxmH8X0RVhdSWzKFT+WJO_UDULCtO4PK+VO-osXwGA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 May 2024 15:09:40 -0700
Ian Rogers <irogers@google.com> wrote:

> > This states what the patch does, but omits why. What's wrong with
> > asprintf() here?  
> 
> Nothing except overhead. I was tracking down an asprintf issue [1],
> asprintf breaking the sanitizer stack traces on my debian based linux,
> and using asprintf for the sake of copying a character was creating a
> huge amount of noise for me. 2 lines-of-code extra means this change
> is by one measure more complex but it removes special knowledge of
> asprintf return values and the meaning of %c, so on the other hand it
> is less complex. I won't be offended if it's not accepted.

I don't mind taking the patch, but the above description is needed in
the change log, as that explains the purpose of the patch.

You don't need to resend, I'll just cut and paste what you wrote above
to the commit message.

Thanks,

-- Steve
