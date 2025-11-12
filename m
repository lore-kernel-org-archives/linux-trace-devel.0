Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDDE33AD8A
	for <linux-trace-devel@vger.kernel.org>; Wed, 12 Nov 2025 16:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762964999; cv=none; b=t7aodrLizcrjUwBKm5rN6h7LcO17A/DOrAuxWEs9jZPpZqei20brWs8TN9bpCPL7Ar3p8JODH6EyURFdJhxtYTdzz7C86BDWJNOrZjBEUJUdrlf5iEmYmA0YfuA/5Ol5q2txUHwMmQIrjD4RfSPcBlkR5nlp0J1Ta7OX4aul/D4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762964999; c=relaxed/simple;
	bh=5JQrpzKlgApWJPPxVffjQxH69yyEhSDOSJhnbB1Wupk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B0iVfyWiKSkcnBI7GVcJJoBQeKd/FXyPwv/thCC79/jmqq9xKFhnDMMJIM/2anWaGvRfElcDN0eEpvQk8znrv3+WTLeirYEgvU3IX3gUYwPe+8ttqBSoVvqT1KWVkPk2U/ujDJs/vcxPCwKchTTObUNgDAGGHITC0MaOaPQXhy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F3B12DF3B;
	Wed, 12 Nov 2025 16:29:50 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf11.hostedemail.com (Postfix) with ESMTPA id D6E052002A;
	Wed, 12 Nov 2025 16:29:48 +0000 (UTC)
Date: Wed, 12 Nov 2025 11:30:01 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Metin Kaya <metin.kaya@arm.com>
Cc: linux-trace-devel@vger.kernel.org, Douglas Raillard
 <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 0/2] libtraceevent: Fix static library to hide hidden
 functions
Message-ID: <20251112113001.3062caa9@gandalf.local.home>
In-Reply-To: <494a7e7f-6878-471f-a69a-f418ef140305@arm.com>
References: <20251112144912.268258-1-rostedt@goodmis.org>
	<494a7e7f-6878-471f-a69a-f418ef140305@arm.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D6E052002A
X-Stat-Signature: kjzy6kjctd7qn5w3tso6dkzmb8mxrbpd
X-Rspamd-Server: rspamout06
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX192fzWyWgX5H7mn66giizU0LlGDlxypIkw=
X-HE-Tag: 1762964988-843265
X-HE-Meta: U2FsdGVkX19RsOKS5s006wjzV++nhiKjKCRgKs++gdY9Z7Wy30sNgBFhhiba16zmE0FhXQI+1TDoUFaZb5HY1SknHFIKvQHfdg4BIyEEG4GU+de0MZfv6uH6MdhCOkqLbwnRL5Ta7r5CcElF/6/LBhNClSOAsEXxScPne6UVlsPEGiXf89xDIo9lZsy2PPt4sfHwcGrFTpPT5DK1ZKiX7cBiwOSbeL7ViULSqHUKY21qVzw4p37t9hnSFQqjC9684Lv78Ao6FzmnzQIDxOmLvIY6Wum56W6l7PFR5JolT1xuENNIvA0nhk7P7Sa4CtRGHfgbU5ppxo7GKIqgnnQTMlSVramu+2gSN7dXWVT8fG9XfND6i3s5YUuLyBhcfS3/

On Wed, 12 Nov 2025 16:19:54 +0000
Metin Kaya <metin.kaya@arm.com> wrote:


> Tested the changes on my Ubuntu-25.04 (6.14.0-34-generic x86_64) with 
> HEAD of libtraceevent, libtracefs and trace-cmd.
> 
> Could build trace-cmd statically. Did not see any regressions in unit 
> tests. Basic smoke test (e.g., trace-cmd record/report) looks fine.
> 
> You can have my:
> 
> Tested-by: Metin Kaya <metin.kaya@arm.com>
> Reviewed-by: Metin Kaya <metin.kaya@arm.com>

Awesome! Thanks,

-- Steve

