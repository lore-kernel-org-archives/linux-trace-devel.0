Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB0C55E70
	for <linux-trace-devel@vger.kernel.org>; Fri, 19 Jan 2024 17:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705685395; cv=none; b=dLtXP319MYyseCU+JY+vAWk68EzRhQVPqgf4/m3nUj32NT/xi/2My/IXB2BadmdFISoRDuWHUJVgGcRYGWWAG4lr/1cXqfZKcQadaidpRRJR0yIx6h5ihy7hk1vIsFSIQkwmxN28sqh8nXgbLSR4nLxsY4ryByLvtYMr2Lbwynk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705685395; c=relaxed/simple;
	bh=htgvEnAzhaV45q2xWz8mbBUQbAfHVAbxQnvrlXJFqSU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F6uFHaftVIFayZoaOp6zHP09bIeCZLPuNhQVVEMTr4Bzd3GhXswr4st919FrVpJ/3hU2fCyEVSfTbbqsM8cxeURfgMFgAQIw8BTaKVHPeaI4VNxQKBAAzo8cvEpsOQlBVXwNw90gKKq2iS/hYjx6oTyXBGpy3xYzbet/IxBzM5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACF5C43390;
	Fri, 19 Jan 2024 17:29:54 +0000 (UTC)
Date: Fri, 19 Jan 2024 12:31:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 2/5] trace-cmd: usage: Update usage for trace-cmd split
Message-ID: <20240119123115.7494bf1e@gandalf.local.home>
In-Reply-To: <efb02cc0-65d9-4b76-9ec6-030a6f39b1c5@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
	<20240112083945.1361293-3-pierre.gondois@arm.com>
	<20240112103731.36beb00c@gandalf.local.home>
	<efb02cc0-65d9-4b76-9ec6-030a6f39b1c5@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 15 Jan 2024 18:22:15 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> > The above looks like it has nothing to do with the usage, and was perhaps
> > accidentally merged in this patch?  
> 
> Yes right,
> something wrong happened while rebasing, sorry for that...

Ah can you send a v2 on this patch series.

For the fixes I can pull them immediately. The updates to the split
functionality can come in a separate patch set.

-- Steve
