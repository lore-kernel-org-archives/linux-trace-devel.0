Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637D92EB86D
	for <linux-trace-devel@vger.kernel.org>; Fri, 21 Nov 2025 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763745080; cv=none; b=fUgFXzqj0MFvwD/6DN0PIv/6IdJQphqVwHfgLJpfdVMXJKKRRQGtmDdORWM4KVptSmTLK1+OxDn3wE3dOVyNbs1p7UYDLINNx1JgF4IVMaWBxG77SpQP3pjbSjCWZOmhKy0mtqL8ecP2EThJPWCsRun0LGjHYxIlGvvIBkCWN18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763745080; c=relaxed/simple;
	bh=Zt+y7grjmr8AM8b84zj3QLzUvqL5DVw6KrTDkZ4JsAg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BrvGjBgnx/cl4acLdFW/X8LsMWp80XTPlAdA42JJ3L6+JWGAkvSjWEX9PMAO1fFhst9JrFef5gtrgIu3+fOPV6r+qvnBRhRVgsiNJTluw8qlZkHjlX0Q7YxKLiV194TJAFsy77fsiVKix1nvfiQbc9nJJ9DTr2GdAaj+3SW74ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5818613B799;
	Fri, 21 Nov 2025 17:11:17 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id DC06E20016;
	Fri, 21 Nov 2025 17:11:15 +0000 (UTC)
Date: Fri, 21 Nov 2025 12:11:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Felix Moessbauer <felix.moessbauer@siemens.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/1] libtracecmd: fix memory leak on partial reverse
 iteration
Message-ID: <20251121121150.5f02faf4@gandalf.local.home>
In-Reply-To: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
References: <20251121134749.1530855-1-felix.moessbauer@siemens.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xmebxnwb6e487qebhiz3ijbwktseisnb
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: DC06E20016
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+Xkhoe6sNzT3a007kelsB79abBbIc/w2g=
X-HE-Tag: 1763745075-605904
X-HE-Meta: U2FsdGVkX19O71UQU1qeq+eWSyotr34wbwBgJijbua4oHcUsQK+lBVoAiyMUVjJuqgxzCoqfpQ6kFe3pxvf8kCHVUp+XT7nT13ONhijRPcEv7/ayoB4BO0yQTG/u0K88mka8aNF9FgKvmUDnyCBGwLgqsH0tAqu4b4KRTeKHU/GcuD2iIrg3w/OrZKBgTJlewr/iak1FcTX9KgNdIDi2+e7uAqU3osRJFFuY55fdKFu1WlTxKXRF+wQlaKG2+dSAy78Y2vOG8FwOYhl8q8II734Ih22xf/MThqK6q54kMhoCa27mfFBau5KtCZqsfmdK


Nit, when sending patches, please capitalize the first word in the subject:

   [PATCH] libtracecmd: Fix memory leak on partial reverse iteration

(I updated this when pulling in your patch).

And you don't need the 1/1 for a single patch.

Thanks!

-- Steve
