Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72913F9F3
	for <linux-trace-devel@vger.kernel.org>; Mon, 29 Jan 2024 20:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706560965; cv=none; b=oK4au74tP7Nbb/7AmlOPNyBSk2NEnqllw6hs/RUz4tYJ8B/m7YdcXLcstI9AI/bKYBgUzpaPQHCjBZE3NHKewyO6KNJjYPX7D5crcZZKpMHzcaq4tPHOw4dNsR11q1h2ZLb/k5/BTeC2uh6hybf99pSI31tgjr2ML9BZZVFNM+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706560965; c=relaxed/simple;
	bh=tZW8CAIjhaf0mtfJqAGa5OlbOGlgQBHZzehX/rIoUCk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ZzLQ12Z1Li2hGeV9CfQl5LPY8Yeztuem/Bq4QY3xZNAyTVcqIWQyOd99ra/3ijkthomXVVNDujd2OSLIXRx/53IZ7b1w3EXGyDPM+q/ESVt6AC1JmkMmW7L9FlMVVpu90DL5pv1fISG3/tCPk2tFkGAqSsD9rv6mFis38g4eYu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Deznzyb2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Deznzyb2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706560962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=uDB3zm3SlcGzM8Q/d+z8zKTK4YPnydA5CsGAUTQo8WM=;
	b=Deznzyb2pj8i/Hckvw6O+skzo64uC7PUB18BFGhDI5MiFOl1c6yNDbZn2MRMEbGGzbwrwD
	lgGBWGAjLm/+KYvumPX40IoYQ0EWtOli5/s8Ns++pKv26JUVhpAsH6V1O1XZJqd4mevHS7
	tHtig4fwhkXFyF0oNqM81J0aMQBQ2Xs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-345-pQZrbvXUNuuhaIoH6durHA-1; Mon, 29 Jan 2024 15:42:40 -0500
X-MC-Unique: pQZrbvXUNuuhaIoH6durHA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CBC1827D8E;
	Mon, 29 Jan 2024 20:42:40 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.5])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 43B562166B34;
	Mon, 29 Jan 2024 20:42:40 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 910B2401E13AC; Mon, 29 Jan 2024 17:42:18 -0300 (-03)
Date: Mon, 29 Jan 2024 17:42:18 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: fix --poll trace recording
Message-ID: <ZbgNqiyocHf/FEQw@tpad>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6


When using --poll, move_data() returns -1 and errno is set to EAGAIN.
This causes the record threads to stop recording.

Fix it by returning to the read loop in case EAGAIN, if --poll
is specified.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 70ce52e..0633edf 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -421,6 +421,9 @@ int tracecmd_start_recording(struct tracecmd_recorder *recorder, unsigned long s
 			if (ret < 0) {
 				if (errno == EINTR)
 					continue;
+				if ((recorder->flags & TRACECMD_RECORD_POLL) &&
+				    errno == EAGAIN)
+					continue;
 				return ret;
 			}
 			read += ret;

