Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10D17BB15
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Apr 2024 23:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714518366; cv=none; b=uzKrQ7dSotlYVTwNHV+8M0PHnw4Aq2Ep2jxj06f4N2fchzRm2nX9VMo8MUajjzm51XfMcf/vIheEIGUWzcfrNyTQzwQZ6ma1pPddtyKKJtekh6HUvu951a/1rvYEYhtiayGCoIGqlAN3ERc2IOBB/7y6+/QeCubMIQ9ICNaDhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714518366; c=relaxed/simple;
	bh=JneaL5HpwWYCn2zJT37fzX/dl1Wmy9rs8PlEhVdSlFU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dN/qEYqbN7dVA907KhZwZtm83PD4xigaYccWO2saE1/qsp73M0qQcRu6yFY4iBPkdrrFQ9CyT3sAQWOlY7iygBuNninBMTr4IYAszDMOYWzRcC+bwE0LZ3ZGI60MFWytGQmytMRhfvwM/RYq5m9rgsQ9DboqO0hFhjcB0VF9MWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46134C2BBFC;
	Tue, 30 Apr 2024 23:06:05 +0000 (UTC)
Date: Tue, 30 Apr 2024 19:06:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jianfeng Wang <jianfeng.w.wang@oracle.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 2/2] trace-cmd: Add ftrace options with fgraph retval
 option
Message-ID: <20240430190647.378f1ac3@gandalf.local.home>
In-Reply-To: <dc8a27e0-ce39-42b0-ad44-dc6f64005921@oracle.com>
References: <20240415154921.4998-1-jianfeng.w.wang@oracle.com>
	<20240415154921.4998-3-jianfeng.w.wang@oracle.com>
	<dc8a27e0-ce39-42b0-ad44-dc6f64005921@oracle.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 30 Apr 2024 15:45:43 -0700
Jianfeng Wang <jianfeng.w.wang@oracle.com> wrote:

> Kindly ask for reviews on this patchset :)

I haven't forgotten these patches ;-)

I was hoping to get to the userspace side this month, but things came up on
the kernel side I had to take care of.

I'm hoping to get to them in then next week or so.

Thanks,

-- Steve
