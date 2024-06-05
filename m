Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C948219D89C
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717604230; cv=none; b=N6SfV8Fgt5rdhXrQpz43grqeQHwIWNZndPmv6/sA4LMdSfIA1KIdhEEeeJ2qGZvpiQ2ZOgaWogSsnEt8arBxwWBYjhLl6Zc33onId0X9gGGsQn0YP/qySnGtQZQaCHcKmcJgVVJaxLoT0md2XYo6/jina867zUjhA5VckoS1Pv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717604230; c=relaxed/simple;
	bh=5zbsyuZbFqjVMWgOXvuxjomNGrp5lUQychtf25t7DIw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A03oXjKGnkMTULg6hfrxQsDIAUCHvbHRiZSPvqG2U7HPCRz7jT5vTtMX8cE3S9VOJcXNtvce/rprlNo7IMtjDr1KGr4+pesTER5S9rBVeOeZiPhKuY/xREoHNboPzc+XKLNMfyiezgn4jNbYl1kt7z4kghl3YnrpKjd9Brl83bM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1BE6C2BD11;
	Wed,  5 Jun 2024 16:17:09 +0000 (UTC)
Date: Wed, 5 Jun 2024 12:17:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Jerome Marchand" <jmarchan@redhat.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 00/38] trace-cmd: fix misc issues found by static
 analysis
Message-ID: <20240605121709.6f2935c0@gandalf.local.home>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  5 Jun 2024 15:40:15 +0200
"Jerome Marchand" <jmarchan@redhat.com> wrote:

> A number of issues were found by running static analysers on the code
> of trace-cmd with openscanhub[1]. Mostly ressource leak, but some are
> more serious like memory corruption.
> 
> [1] https://fedoraproject.org/wiki/OpenScanHub

Thanks for the patches. I'll try to carve out some time to review them.

-- Steve
