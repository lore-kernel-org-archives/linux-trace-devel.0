Received: from mail.nearlyone.de (mail.nearlyone.de [49.12.199.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287831A619B
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Jul 2024 16:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.199.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357610; cv=none; b=p/3qrJSX9RdXQ2ui9XmTvUSe4FJvX7UZaDJAGWgzs3v/+xh5GmVPndIgmHYJSGz8OWrEXMRScJakl64j3Iry9nU4nwGYse8d4i882gGNUyjQURhsHkSQ0hzq6FclN3Guqx6nyUfX/CHRJkGnXR7WAyA/lAISRqY3wAuGs5f54gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357610; c=relaxed/simple;
	bh=NxW7r6yTsmvydZzcDm0I7e1cszJjBP2vm5PY7aWtJHY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=St5O4e4Ur2+4ALsbNLYZnY+MGB5sPvqnLDvYfMw27ArwHnxU2mi8W8WE/QJaJmxEa5TBq3Qsst9HxWjej3JW85v6UTqZQ9VfvbMFe7qMie6NSwgEice/7FUvOcRFM77TzFfRHgu31D4xzQR5SWzlyUfqo4UV1VMNeuJeD/vmGj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org; spf=pass smtp.mailfrom=monom.org; dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b=ASG59yYj; arc=none smtp.client-ip=49.12.199.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=monom.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=monom.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=monom.org header.i=@monom.org header.b="ASG59yYj"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id C60E1DACB4;
	Tue, 30 Jul 2024 18:40:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=monom.org; s=dkim;
	t=1722357605; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=ojNmDnE8SPCydvnkSQ3GOA1W16ysm8fOV4xwNue1qwI=;
	b=ASG59yYjs7+pw+ctvlCtucYAoYkD47snOOW9WIPlk5e7V14l1peCAHmI678lP9tPy/jYQ1
	JgQ0DczVRGKrCzlJFw5i2+iqORvqGdHLtKEveZB8VSoXC1Ksd5G0HYYexeH43PnzLzehZd
	9Aaju18n7UI+HTj5rmH2QDcCe1TeCuS9s9fdQW9ECMEkNjOlHHgk9Rb3ai3eDns12qMTi/
	0+18CEpwuBy+u0rsXu9FfvgO7zsKYwwIbZdVU7eIXbLVVzPqjB6Z5Yht5IvVWdeDnGHU1Z
	tw7rIMtgPGjXIjLeW/4Q7DuXm1IF8F5HhNJvmfW8fB4T4NFFsoE4/hzZRfXmSg==
Date: Tue, 30 Jul 2024 18:40:04 +0200
From: Daniel Wagner <wagi@monom.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd documentation: Remove check-manpages.sh for
 trace-cmd in meson build
Message-ID: <kpns6smx76jpzbxuf7zaqdrjmuevbb7zs6nqoewvde46ewots2@oljigi32qzra>
References: <20240725112620.17c6d1b2@gandalf.local.home>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240725112620.17c6d1b2@gandalf.local.home>
X-Last-TLS-Session-Version: TLSv1.3

On Thu, Jul 25, 2024 at 11:26:20AM GMT, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The creation of man pages for trace-cmd ran the check-manpages.sh script,
> which is only used for the libtracecmd library, not the tools. This caused
> the build to spit out warning of grep not finding libtracecmd.txt.

Ah, okay, didn't noticed that back then.

> Fixes: 736df0648d16b ("trace-cmd: Add initial support for meson")
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Anyway, looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
