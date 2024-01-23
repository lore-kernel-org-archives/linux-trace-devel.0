Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BA55251
	for <linux-trace-devel@vger.kernel.org>; Tue, 23 Jan 2024 01:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974576; cv=none; b=uaL/8fr2mbP0kax8LrGFf2IcMnUAp0vWMP5Jv0gaCtNA4Pn2WuFWw1tGPypB3fJGyI9UXNH0InRDoWuqCfXon6Ehq9ljhYBADBTfGC/nEXad2uU/YNKTgdSG44WMzjb3v4M2Xi/uAtY+s1wBq6kkTpJ88q1ZJTc/kxT4i45FBIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974576; c=relaxed/simple;
	bh=WY55YN03+BnSy/CpgGF5dpoi5HZoC1J9J9jWRBhkiWw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SflJTszfig49oe6g/p+NcObDx+QCh0oyOT++OLnnjBZA7+TsOUflOSuK44L+9GL4XFGUUJCVCtI2equD6tTQ8qeu19VMiJEmdVSwLOt1FGu9OSfxPzSunj6LIj/cBg1Yr8J0pLV92XATbHKXosUuqSVpbc3nrKVM85LiDtwp1U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3BFC433C7;
	Tue, 23 Jan 2024 01:49:35 +0000 (UTC)
Date: Mon, 22 Jan 2024 20:51:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] trace-cmd split: Correctly split with
 start/end/time-window parameters
Message-ID: <20240122205105.655f6392@gandalf.local.home>
In-Reply-To: <20240122164336.167256-3-pierre.gondois@arm.com>
References: <20240122164336.167256-1-pierre.gondois@arm.com>
	<20240122164336.167256-3-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Jan 2024 17:43:31 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> With a trace.dat file having events timestamped between
> [284443.0, 284448.0] seconds, the following command:
>   trace-cmd split -i trace.dat -o trace2.dat -r -m 100 284444 284445
> should produce ten trace2.dat.XXX files between [284444.0, 284445.0],
> each one lasting 100ms.
> 
> Currently only one trace2.dat.001 file is produced, with events
> within the [284444.0, 284445.1] time window.
> 
> Don't stop splitting the input file after the first iteration.
> Add a end_reached to detect when the end timestamp is reached.
> 
> Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
> ---
>

FYI, I applied the first two patches of your series. You don't need to
include them in future versions.

-- Steve
