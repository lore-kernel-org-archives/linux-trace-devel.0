Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB393EA95F
	for <linux-trace-devel@vger.kernel.org>; Fri, 29 May 2026 15:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780070139; cv=none; b=lQnXVP3sk1FIgjYQ/sOgilA48yvBiLGei/9qRMyPxWISvfhgG8APT/tTuAueVQoKYleIt2Z0uKZKjckBQG2PO1YT2883mpwtGnwwbyUf8qVjhhmxxX09I3x0kbH5+GwZaQgtPlbjeiCe62jesn4LEeGZfRwcG78FCsfyetQ5GWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780070139; c=relaxed/simple;
	bh=vixlBSDVFzt+Zk1QEVQmASbTHipfhyoPGqZYkCBFHoY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=P0WU1kf/58QrXHnA1w/r5RfeIf1SBoxRhOOBIpXMTaLQjSBLKg7t8uGQV82kPcdWFlL8wZhnrzL9hWjDbt8UWl4ayWmtYRnUt4ZDOjHW4NV+MAszpnGbbPxwPC7HoJhOebCitratCIFfP95uL07S/F0H9KLKUyMVwmMf0TAriJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8D1B240224;
	Fri, 29 May 2026 15:55:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf09.hostedemail.com (Postfix) with ESMTPA id EFCBB20028;
	Fri, 29 May 2026 15:55:29 +0000 (UTC)
Date: Fri, 29 May 2026 11:55:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
 helpdesk@kernel.org
Subject: Documentation update to KernelShark
Message-ID: <20260529115528.1d0f92a5@fedora>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: EFCBB20028
X-Stat-Signature: izus1hacy4s9wjd3j8wopsqwznzb4i9e
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/hxngkC3y9leS2r7GsOjCt0lbHmcrcApA=
X-HE-Tag: 1780070129-506259
X-HE-Meta: U2FsdGVkX18OWDvwB9lgIiRwy+R1UegrJt0Yt2vjXSa+lXHXCtpz/wc3x1OqxfJXy0Dgi6fkTcPSh79fzwnvHIYj44tOswBtxvTrxQndQJA3dT0EhDANkuB0LH9uxGRLoIRgJYp+5Y9rHDECqSBctxdgJz3vgwGRG9T9yK9JI7I0wI4PFrrhPDV36wqlyou+bTIAI311YSaf24GdaiTqBtxz5W0D+BN5ekft1S0hF4iodthQgs2Iitq9Di/lx6eXD3Z3s1IshcLtlkiafn1rzdGE9T7boiJwKpEsonb49XyDMBH7kG0GVZrZIavoCvzYeXKDYkL4Lf+bNjgNvU34iI+WECVDAd80crAVihr+iDZiZQjM4cj8Wg0UXATF2drAazhCArzvrSo=

Hi Yordan,

Can you apply this patch to the KernelShark repo:

  https://patchwork.kernel.org/project/linux-trace-devel/patch/20251031115513.41b86970@gandalf.local.home/

Also, you probably should have your name added to the PatchWork so that
I can delegate KernelShark patches to you, and that will make it easier
for what is needed for KernelShark.

Do you have PatchWork account? If not, we should get you one (I Cc'd
helpdesk@kernel.org to let them know you need one too).

-- Steve
