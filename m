Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C932E3E8
	for <linux-trace-devel@vger.kernel.org>; Thu, 25 Jul 2024 19:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721936642; cv=none; b=ZZvFHQao7UxygQPSgCCrKpmgbxv7gSzbrtPQvlx+PXPVtf6uHVGog7KKHIDjxQ+E8P9bOFaP6ot15qi6CbgC9oMQVb7mOCPVokCaM4QPKlNO48Kjnl4+nmoCO6luQ/3y3g1wfEBqjqjRS9mo25oeSE9NQQwYzsMDOVGUU0BSOqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721936642; c=relaxed/simple;
	bh=iOgckgZIP8V/v5wl2dXhqiE/TAyosfybipLGnX/Uyfg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3YXbnMOqO5i0pBN2ukHqQ8aa53FWmdWt1ckS4mQu+OlxN+zrqHjrC6EKIIAnNPYmGm0CJX1bCY/D5LIi0xouuF2GQYCai3ZFOa3v9tnbg3VhaIYG0fgjV4O8uQLnvfIHyWajbzSCjyKPUM3iqfbcaaoVDIEcbekuBi+YcayCRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F16BC116B1;
	Thu, 25 Jul 2024 19:44:01 +0000 (UTC)
Date: Thu, 25 Jul 2024 15:44:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Sojka <michal.sojka@cvut.cz>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtracefs: Documentation: Add missing documentation to
 meson.build
Message-ID: <20240725154422.0117f3e7@gandalf.local.home>
In-Reply-To: <20240725143741.2415412-1-michal.sojka@cvut.cz>
References: <20240725143741.2415412-1-michal.sojka@cvut.cz>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Jul 2024 16:37:32 +0200
Michal Sojka <michal.sojka@cvut.cz> wrote:

> Makefile-based build uses $(wildcard libtracefs-*.txt) to
> automatically find all documentation, but Meson needs explicit listing
> of the source files. Recently added files were missing from the Meson
> list and this commit adds them.
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>

Sure, send this out the day after I release libtracefs-1.8.1 ;-)

Thanks, but it may be awhile before 1.8.2, as I'll wait for more bugs.

-- Steve
