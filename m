Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDB433997
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 20:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195246; cv=none; b=bkp/5SiHCSQ6mPxycYSUFpl6GlnY3Es3L7ieWyORkD0Hnub8zgxYnZH9SbNDp4Fs2qQeFyFA6kiszgwnrL1v0PYeCoIZ2Q0L7Aa+qgS4Fo8idz463V1S4kAFWrrx1Ne2WHZl/XbzfCEvovEbkcLnQOxGi1EN32D4brav7w234CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195246; c=relaxed/simple;
	bh=s4W3x4OhEUuu9SuCml+PjWUMymq6c4B2N5XwL2137F4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UD5HFRqUdvf9/+nDLXYTOBnbpVWhR43yc5F0UA3czq4BOjbv9kckAcDSOGSRzO4twmJ4OAzksrn/5R5tB5hiQS5EIR0oGDPU432nBEQbtaUCluBZH/N3LXgkCgbmFbADiEdFESia4GUJxZgo/pswLB/L3xAe91ZZL9whN5SYDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38685C4CEC3;
	Thu, 17 Oct 2024 20:00:45 +0000 (UTC)
Date: Thu, 17 Oct 2024 16:01:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtracefs: Destroy synthetic and eprobes before other
 events
Message-ID: <20241017160108.4f99c917@gandalf.local.home>
In-Reply-To: <e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
References: <20241016123552.55efa78f@gandalf.local.home>
	<e6ddd9b6-ce83-451e-8344-24ff620245cc@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Oct 2024 09:38:35 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> I see one more failure in this section of unit tests:
> 
>    Test: tracefs_iterate_snapshot_events API ...FAILED
>      1. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>      2. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
>      3. tracefs-utest.c:235  - ret == sizeof(struct test_sample)
> 

Does this occur without this patch? IOW, is this caused by this patch?

> I did run trace-cmd reset and unmounted my tracefs before running the 
> unit tests.
> Please feel free to ignore if something is weirdly wrong in my setup.
> 
> Other than that -kind of existing- failure, the patch looks good to me 
> (e.g., trace-cmd unit tests are working fine).


Can you add a printf("ret = %d\n", ret) to find out what "ret" is?

Thanks,

-- Steve

