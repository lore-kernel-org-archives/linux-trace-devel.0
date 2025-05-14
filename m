Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F62918BC0C
	for <linux-trace-devel@vger.kernel.org>; Wed, 14 May 2025 13:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747230362; cv=none; b=pD0Ac6cSaMGIpNJsHG8FAQ3CTguRTq6dAlQL0o/vjAQYYNvVlck2DdH8IppzluS+rdiiJrB7u3gMMZzJQI1btQ78SIAK4assOE1rYc0aSMXXisExil0NfM75Q1qbPnP5+cv5fWMG+od9DtKHhEMZQn57guZlc8GjSKv9HJF2Gbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747230362; c=relaxed/simple;
	bh=2/zKeieP0M+/p04tDO1SBWrm593h+qUORelozOsAWjM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j89tMZspup/+kQEK3kDXOAFlFFjPIEFJ6Gi3ZEJ8xJLMJBZTXq3LJrefS6t/+rpX8hjdXAkyALb7b5t9dT4T2hPpeHIBAvY96M5MhmNNviRg08x788ycKhJrBRE80uY09I1CdVOmn26fbNoErwl/DMcI3BzpMjPcwpHntd23enQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B886C4CEED;
	Wed, 14 May 2025 13:46:01 +0000 (UTC)
Date: Wed, 14 May 2025 09:45:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: linux-trace-devel@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>
Subject: Re: [PATCH] libtracecmd: Support changing /proc/kallsyms
Message-ID: <20250514094559.34927422@batman.local.home>
In-Reply-To: <bab0be078205af4c8d38e8211accc402ac6b6a4a.camel@linux.ibm.com>
References: <20250416231325.14113-1-iii@linux.ibm.com>
	<bab0be078205af4c8d38e8211accc402ac6b6a4a.camel@linux.ibm.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 May 2025 09:51:16 +0200
Ilya Leoshkevich <iii@linux.ibm.com> wrote:

> > Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
> > ---
> > =C2=A0lib/trace-cmd/trace-output.c | 66 ++++++++++++++++++++++++++++---=
---
> > --
> > =C2=A01 file changed, 52 insertions(+), 14 deletions(-) =20
>=20
> Gentle ping.

Thanks for the reminder. This came in just as I finished working on the
libraries, which I try to spend a little time on every month.

I'm about to leave for a short vacation, but hopefully I'll be able to
get to this next week.

If you don't see anything by the end of next week, please send me
another gentle ping ;-)

If I can catch up on everything I need to get done today, maybe I'll be
able to look at it today. But I don't want to get your hopes up.

-- Steve
