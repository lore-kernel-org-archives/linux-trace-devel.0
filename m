Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E40815ECEC
	for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2024 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721841251; cv=none; b=d1TTBPUCY52z+4sMNOqPm0k9osfKrauvglkFdesU5ds6L9Mx0+3Yu/ItgiwpqgM08+VwbMbJ38G3L3tMd7O6apj4f06BID3z5IdHRMQIQdf/Sw6wPPHgvYn43kK9mlmIokwtwps+177CLBsytUsJAz+g8k28i9WLsHtPCkwy5R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721841251; c=relaxed/simple;
	bh=+Z2aOAxITIM2TOZ3IKrd8RJxOt07y7L0LL4QURGSExY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EURgPQMD/r+um0rf+teMTEbv4E2KyGwLn8juoB7agUHWCewjjhwZQBtFJfGY+9+lz5fj5q5m8CtXQsp7uG7yG6pG/ck+lBwRkTqOSQiS28D3QXem++KXYc7/4rS3Gkjt6ip9uO0Af2LJIRBOdEZTDbMfP6eo6iItXuxNv4xPMSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FA6C32781;
	Wed, 24 Jul 2024 17:14:10 +0000 (UTC)
Date: Wed, 24 Jul 2024 13:14:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Schmidt, Adriaan" <adriaan.schmidt@siemens.com>
Cc: Tejun Heo <tj@kernel.org>, "linux-trace-devel@vger.kernel.org"
 <linux-trace-devel@vger.kernel.org>, Johannes Berg
 <johannes@sipsolutions.net>, "yselkowi@redhat.com" <yselkowi@redhat.com>
Subject: Re: [PATCH] trace-cmd: python: Update python module
Message-ID: <20240724131428.43b0d264@gandalf.local.home>
In-Reply-To: <20240715111250.2b2ba512@rorschach.local.home>
References: <Y+w51nOhNd+PGo/k@slm.duckdns.org>
	<20230214205354.51f119c3@rorschach.local.home>
	<AS4PR10MB5318B6DCD04F15271B9360DCEDA12@AS4PR10MB5318.EURPRD10.PROD.OUTLOOK.COM>
	<20240715111250.2b2ba512@rorschach.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jul 2024 11:12:50 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 15 Jul 2024 12:11:57 +0000
> "Schmidt, Adriaan" <adriaan.schmidt@siemens.com> wrote:
> 
> > Hi,
> > 
> > Bumping this old-but-still-relevant patch...
> > There is a related item on Bugzilla [1], and there was also a more
> > recent proposal to touch the python bindings [2], and I believe the
> > issue addressed there (use old Python API) would also be fixed by
> > this patch.
> >   
> 
> Thanks for the bump. I'll try to get some time to get to it in the
> following weeks.

I finally got around to looking at this. I'm going to add it to trace-cmd v3.3.

Thanks!

-- Steve
