Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB133CF66B
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 14:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777042640; cv=none; b=UYugzrLJIimXXGhf1EdCc3Ry9VfMJSszlSTdrfFf2IbDPRu93YUk7xR9xJwdl5h+tQ3HZK82mzJsiszoydTWeD1MNHz6xrzW6oaxO3Fqky/H70rqlvng+uVWYsZkJjDhUBTSaYV8B1Umc46xYRL/IH5sYsVszUUSXQp7QycENzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777042640; c=relaxed/simple;
	bh=lQ1Ts3MatlfkTjI0FfeKmlGCubiziClJ3Mm9cvBPVuQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WkEgu7/RhQaNYc94sY04R2TyN/rlkP1cys9OHjtstjpmobTqB9FL898gRiZsBTs/ibZhDz+sT1Escr6VRzJ6B/ipoiIQGzYJK9qpZy5cTBpnCntS3zKP8OS1vB1/BB/s0OFPxtfjnKujUwRXPJSIrwNbZ7sZ5k00Y648IGtgRfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E101C06B8;
	Fri, 24 Apr 2026 14:48:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id A699B20010;
	Fri, 24 Apr 2026 14:48:53 +0000 (UTC)
Date: Fri, 24 Apr 2026 10:48:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] tracefs: Add tests for clearing kprobes with
 tracefs_dynevent_destroy_all()
Message-ID: <20260424104854.56d2ec9c@gandalf.local.home>
In-Reply-To: <4aacf951-c96d-47e5-a4ca-9e0eee8d3928@arm.com>
References: <20260423162207.5a888de0@gandalf.local.home>
	<4aacf951-c96d-47e5-a4ca-9e0eee8d3928@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n5wj3ynb9cjzkyey4j788kaa4jiwfgaa
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: A699B20010
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+I1/Yl5JQVBm1x6G5cZzTUVGtm2kS2akM=
X-HE-Tag: 1777042133-493813
X-HE-Meta: U2FsdGVkX1+T55eOnazzeLhiUpJJkuGXnakvSTG74BqHZvsR/MdQNWbnqEqkg66bSCQoHVZADAXNqXpdspSFW2ne/qONCHyivrNlv020DncgoWsdI974IKNGbJnY6UygGDyEIUUo1t/3zvyhiLPCYnObtO8/s8kpWZVEjrlqIheZlYuINrgT5d4oyuU/StE8qil2t1z7QBxS6vnKbsFE6ejInLBe5WR8oyj7IQvB1NSysBToshHN6ep904JanTl/N7bXzZn0FRbd31TvyEFCGrX8JxcEIp5So4QtfN4ccnYigMHptp+L0HmfXOUjSO1FXeLmtfWNBwajKpQkjV8kJbaECicl+7m4/El9EyZaqoGoBnfeh00PS3XVgRTn6cVq

On Fri, 24 Apr 2026 09:04:10 +0100
Metin Kaya <metin.kaya@arm.com> wrote:

> > -
> > +	CU_add_test(suite, "kprobes", test_kprobes);  
> 
> I think we can keep `kprobes` in its old location to make the patch simpler.
> 
> > +	return;  
> 
> This line should be left-over from testing I guess :)

Ah crap! Yeah, this hunk was for testing purposes only.

Will send a v2.

Thanks,

-- Steve
