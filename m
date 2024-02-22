Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA39014E2FC
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708617750; cv=none; b=KdC0PrwT82pTgZ3nuDgNUPuaGVOee9LyuKzIzARpleRM1j21DpF7i6+vjoL8kVtoNPzn1ztwvkTk+1c9EzsItBX//ZKVE6lUDK6lcBNRfrzHv41h/QMTZ5BuT13YQxDuFuxR50uNifK08xOnHPOywDkw4EEjLCpJ50g9UN5v1rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708617750; c=relaxed/simple;
	bh=j5B+0jXen/meXMNgwLaQqFx5rYY+4k5J2ynw520g/e4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VxK9/AZid2SWP61TQafGQkhR78d8dmacDDVGkXfc8EYGDW/sM3iZb8lm4DIRIs/I7F90NhYEer48yqiochm6MMnkcsvBkWkTMFMwOY8YISMfTzasHmHDkbr8Pju9y3Rf7LC2Kn5Wt8ZdLMZAUvGdMGmJL5y/fEvjv8C2xgx/+FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CA4C433F1;
	Thu, 22 Feb 2024 16:02:29 +0000 (UTC)
Date: Thu, 22 Feb 2024 11:04:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org>
Cc: <mikoxyzzz@gmail.com>, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] utest/tracefs-utest: include linux/limits.h
Message-ID: <20240222110420.47a9c0ec@gandalf.local.home>
In-Reply-To: <20240222095345.7de30505@gandalf.local.home>
References: <20240222-utest-fixes-v2-0-ba9cd06b41d3@gmail.com>
	<20240222-utest-fixes-v2-1-ba9cd06b41d3@gmail.com>
	<20240222095345.7de30505@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 22 Feb 2024 09:53:45 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Thu, 22 Feb 2024 11:12:44 +0100
> Miko Larsson via B4 Relay <devnull+mikoxyzzz.gmail.com@kernel.org> wrote:
> 
> > From: Miko Larsson <mikoxyzzz@gmail.com>
> > 
> > This fixes the build with musl + clang >=15; musl doesn't define
> > PATH_MAX anywhere else, and clang >=15 doesn't allow implicit
> > declarations with >=c99. Without this, the build fails due to PATH_MAX
> > not being defined.
> > 
> > We could include limits.h from the libc, but AFAIK the libc doesn't
> > necessarily have to define PATH_MAX, so it's safer to just include
> > linux/limits.h  
> 
> Actually, the way I handle PATH_MAX is to add:
> 
> #ifndef PATH_MAX
> #define PATH_MAX 1024
> #endif
> 
> As it's not really used, but just a default value to be able to add any
> paths used in the tracefs directory, where 1024 is more than enough.

I'm going to apply your other two patches, but I created a patch with the
added code above, and will be posting that shortly.

-- Steve
