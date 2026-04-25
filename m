Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCFE282F1A
	for <linux-trace-devel@vger.kernel.org>; Sat, 25 Apr 2026 10:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777113789; cv=none; b=d9D10la4nsohVHouZWgEXnOlu//MRHNX0HbzYk96vrewtObZI2i7Q+G+kutmG/ORfIRcBhAigTFVIjlK5tpkkMm15elLXiZnGGqianKA+QRd9qNKIhjlOnynSeINgrn6im2Vvu2GJdY2HYeQKdZhH0j7oU9+VH1sd/6LnEVp0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777113789; c=relaxed/simple;
	bh=QvTQGcVJZzXO+WW669jSvq9sdMPFamim4OYnu7IZNZI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=Zm5605QuDkrM64bapuRe3ZZGNcqPgSRx7q0gHWu/lkOfvz7fNQp96//+II7QtzWY95x+Qhm266lEhvCSoMNcAWwUmkbAtHKC0qkwdmugovM7NjrjYv9PMFaItbLBUqnbFpD/ae6ZI1G8aX+h0qn3t3rpixNChXzfLUq7nPNhB2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=a.krabler.eu; spf=pass smtp.mailfrom=a.krabler.eu; dkim=pass (2048-bit key) header.d=a.krabler.eu header.i=@a.krabler.eu header.b=dKWT61rA; arc=none smtp.client-ip=80.241.56.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=a.krabler.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=a.krabler.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=a.krabler.eu header.i=@a.krabler.eu header.b="dKWT61rA"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4g2md20bDyz9vTl;
	Sat, 25 Apr 2026 12:43:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=a.krabler.eu;
	s=MBO0001; t=1777113782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QvTQGcVJZzXO+WW669jSvq9sdMPFamim4OYnu7IZNZI=;
	b=dKWT61rAjieEZPyYFlNvxKJJj2Qyu4lR0UehkbKkJBphlpjKDjYVwJmu+8zo2o0siCPNGT
	w0b8gG+ciH/kCNlE5aPDmcCvOzJx1WyftbwrnhRugoSpM12MBEDXc30N26eiHVeKRqPH7n
	XApHBSSPNg74jK//OPHtySMVZoF1VndCN2K6CFP5V9HV1lD3SQKtVeoomGxUY0CljP6f/b
	SzEZca1/mJNOt0PlPV61jgDoPf/du7TDNbv8e69culWUIM39WMlzogP3jvRYlQWM8tEJRF
	VJid30p5KHLsqR0heBAAQu/9y/RTkRMqJiS8QIh/3ctV83WjnbD/dqmae84GBA==
Message-ID: <92bc5675-6035-4a24-a3af-f511e92b0479@a.krabler.eu>
Date: Sat, 25 Apr 2026 12:43:00 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Alexander Krabler <code@a.krabler.eu>
Subject: Re: [PATCH] trace-cmd: Fix extracting instance in RO directory
To: Steven Rostedt <rostedt@goodmis.org>,
 Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20260424151531.3c9be298@gandalf.local.home>
Content-Language: en-US
In-Reply-To: <20260424151531.3c9be298@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Steven,

I build and tested your patch on my machine,
I can confirm it fixes my issue.

Thanks for your quick patch to my report!

Alexander

Tested-by: Alexander Krabler <code@a.krabler.eu>

