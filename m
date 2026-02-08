Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4113F2DECA8
	for <linux-trace-devel@vger.kernel.org>; Sun,  8 Feb 2026 21:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770586341; cv=none; b=kgTUiDvuOKpK7kfdRHn+OoRuxFEWhgbYKWemZot9pc4ZJ24yH4UL8uZDIwvBth5O/mEwKw+g4QXNEVitV9yiN4G1tegWEog5nWIQnztwP/E4ld4Dp+RXlypg9vqkRpNYHO324YVGSQtJZ63SWxtAQVcwD0uU8fkl1F72PFRAEaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770586341; c=relaxed/simple;
	bh=mxaMXojYBDuiMjs97DADvxLHrN9gpMywVT5yKsRWgPo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uolMQ9kpboenSB37KyeUdtNXlDysZ38jhaWI32ixZeKKzxftJxD3AJgo7PczPsPhCBCi5IlshtCxMLaPEnh45YND43x4tQE4tOm+/mdx/f2NBvtR0lcEKAJVxW2+vdjD+KKj3LEdlZFtnrEWbjigkMfiIKg59g1DvGLFaDaWIZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 069E313B46E;
	Sun,  8 Feb 2026 21:32:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 7C1D42E;
	Sun,  8 Feb 2026 21:32:12 +0000 (UTC)
Date: Sun, 8 Feb 2026 16:32:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Giulio Benetti <giulio.benetti@benettiengineering.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: Build failure bft for trace-cmd and libtraceevent
Message-ID: <20260208163211.63e645cb@robin>
In-Reply-To: <5984db8a-a93a-4efc-9b81-c87140d38042@benettiengineering.com>
References: <5984db8a-a93a-4efc-9b81-c87140d38042@benettiengineering.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ofboi7ahiospfc8p6rd69jii37nr55fr
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 7C1D42E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19HTOr4/QWLRX4Q2X5HmCvPbUgHNjZhOm8=
X-HE-Tag: 1770586332-61504
X-HE-Meta: U2FsdGVkX1+RCHwIH1sW+NUUIZwsxdJrDtsUq7bL8l3pM3TPHpbRoCF+7Lh+1rl/njODAMDGoZLkulXg6jvbreoyn+ubwBlxCIzkjDzEHqCMswrNENv6yooORa6KaE79dLyRx2K82m9qGB19/lrD3AXaiYHWG7TuZUicMLrn/M2pMPgsm+s6P5VKuJEZo9KBRuCJpH2k28a/kiuv8XNDRB6kCqZUt2FsvQxPnv7ja7Pp/lbFmSnzk0vda4ZzVDWumrSdlE1l2O3nC4fr89woqONRcBC+ieZNIFanH4Io8eCflEbzEmewTzKj20zuCmrU/+6iMoqEpr+UZwgqzQEPOmFQ8bkUtCC3ohniV852Y7tpJWNlIVaUHkpj0uaLeR8EP29fTAgCW0ej77k+pcwLAw==

On Sun, 8 Feb 2026 21:53:31 +0100
Giulio Benetti <giulio.benetti@benettiengineering.com> wrote:

> Otherwise the solution could be to switch according to Linux version
> between print_args() with and without bft support, basically re-adding
> the function here:
> https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/commit/?id=e798103c0815e6642e74d9317c325b2c62681f2e
> 
> What do you think about it?

Is the failure found at runtime? That is, the loaded BTF file doesn't
parse correctly? What is the error exactly?

I guess if the tep_btf_print_args() fails, it should just print the raw
args then.

-- Steve
