Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE034C754A
	for <linux-trace-devel@vger.kernel.org>; Thu, 24 Sep 2026 19:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790279582; cv=none; b=UbzWjN/QU2coJh1oktlJX/wX0XOlf6HtNsDnJZqhWE5O/T6YBtn/rHeV5BDMqUTObNq/eQ8P/jVWfh+Jdg5/raKSLhkMNMuQpVxoi0TnAx6T8Ze95o8xFZN5Kc0ezCzLbCHfBZHnteX9zUD5vpXhryEPTFabNWRhiW+/S7Vk9j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790279582; c=relaxed/simple;
	bh=7BaPMD2iREsvIe3/WVlc4ElmZpO1J9l9uPF0rIeLW2U=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVUc7a2X1iyO0mZdhOFwfmoHzPobSyruCJUvlgpOD5RIyhOjcvkw4qUGDzsfsF2yIbEBnxhQLS529kqWgBAoMWN57GBMEpGXJZoKuAPpF0a7vZxRXS3h/EzgQZw3MmZ1rwkgxpXNyRq3aRMVMzQepSIQogj0wCGrX8NOgR5W7I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=VDVoEq1u; arc=none smtp.client-ip=216.40.44.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="VDVoEq1u"
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60112A04DB;
	Thu, 24 Sep 2026 19:45:39 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 9D4A42000E;
	Thu, 24 Sep 2026 19:45:37 +0000 (UTC)
Date: Thu, 24 Sep 2026 15:45:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Benjamin Drung <benjamin.drung@canonical.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 0/3] Ubuntu patches
Message-ID: <20260924154534.318f6ec2@fedora>
In-Reply-To: <20260923205650.2638166-1-benjamin.drung@canonical.com>
References: <20260826163726.1fe4677a@gandalf.local.home>
	<20260923205650.2638166-1-benjamin.drung@canonical.com>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1xkobtoc3wi8crw3osasz1inm8umg7nm
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 9D4A42000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/GQnTjGCFDU3An0l0CEzDPW/rs1iPpnco=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=slduklT8LDS8TqqeJquEoV03fPt+q4hsNHFOHjBs5MA=; b=VDVoEq1uc9/nNDhhDTevyPKw/cRThOrbZpQRG3NB4NTcsbRmGyJmfkHMsD6CbplDpAQn7sO2mUy0BZWGNpwogo2Fir7CnVhwo3Pmz+qm8zP8/9ALsRRiowAWpCsTLeMxW26NMnd/X5xEfgOD4Jw6t6Pwykt94B2fNizT++gJdN8=
X-HE-Tag: 1790279137-458451
X-HE-Meta: U2FsdGVkX1/uXGEBCljgtfblD40oswwPpWVYpHuO5zhLCY/KFrIxnyUM0c9krBPUWsoxXfz1cOsgLG2dICcYPxMNlQqGm8HPhBlURscDj+fTIxb8fLZA+VSTUuDyWEV9+rnHFYrfFPpaePzLhMolAk3WGGn3/tIx6fs/oKqF9JiZ7l8I3EF5n0YOXmEV/OCDhFsv2Fh5vyhFzqmHiM4TujS40GrxMc/N6bH+pvcO/szOj+YDo1urqH8kaWQHeX6eQLakIgyLdB6mc80rGnQy057KiJHST2Ek+72xfMh1b5hlUUZlzoaHOjIPOV7qQDVH22fzQNVjDbf6DUjeZyDfW57n21b7FVwBk+W8TkFgp2bmVjKJ3ajOdzinFamZ2600fCQJ9bGdwPJi+4wzsYvh+QnxiILn91+/GzNJlvWew7DA6DDblbUIig==


Thanks,

I'm actually in the middle of traveling until Oct 10th and will likely
not be able to look at these until then.I'm hoping to triage the bugs
and changes sent to the trace-cmd and library code in October.

-- Steve


On Wed, 23 Sep 2026 22:56:29 +0200
Benjamin Drung <benjamin.drung@canonical.com> wrote:

> Hi,
> 
> with quite some delay, here are the requested changes.
> 
> v2:
>  - Added missing Signed-off-by tags.
> 
> Adrien Nader (1):
>   libtracefs utest: Only use online CPUs during tests
> 
> Benjamin Drung (2):
>   libtracefs: Use LIBTRACEFS_STATIC for utest
>   libtracefs: Support EXTRA_LIBS for utest
> 
>  utest/Makefile        |  7 +++++--
>  utest/tracefs-utest.c | 10 +++++-----
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 

