Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321B200BA5
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188906; cv=none; b=Rzfl2Gq6FRRxQEKnUKMaeSZAuwZC68rJQzV2pgRa6cgqxvMvpxxy8oKa+Q2yw1SyJ0xdumS+EWVem3GvX8i1VzU0hM7yshd+RT0IYOrfZT4PqlnJ9S/XOCbROt2cab3SdU/mb0DLzAVMdH/N9gGOW8N0bd6OA1Omyz2HmKTuOfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188906; c=relaxed/simple;
	bh=1PWNVvSwBChOcelCpN/62fYpO6yD/aFkjm6W18kH2qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSwLD++5zhF10C0G5hIvrXieJRGbOWXB9okClyfSTobCQbmGVH/Wij+G4inRpPaJZTb/8v9+ctXORaZBGmB1z72tJzJ2pFLMtMW7qN11zMTx9mJyCQ4ZZkoIGe8fMsNrfDk+XdqMModPFeYGNJ7ERnh7SIzwFXs7tdjmA6ozrUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AIlIwZbs; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AIlIwZbs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cYwY3B00Kew8YA/PeZK0DP8ZifQytq+XGooNYoSh/ME=;
	b=AIlIwZbsdGR1cfURO2Q54hcj19A36ghvc6Y6B3pLdTLX2mmwsVOzwl2dmwQo2JLXsFtHIt
	1WKpUJrALZBlAu2OmUaAWZ5YjmsY5R8QBVfISrb/elbF0dv56QXENcmZVZ3w29/BjcLTBr
	LomaLkGn3I78tGOcnSTCliO/CiFdlCY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-359-AHznrfWgOgyBLrUPFUJjNQ-1; Tue,
 29 Oct 2024 04:01:39 -0400
X-MC-Unique: AHznrfWgOgyBLrUPFUJjNQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1D70F19560BD;
	Tue, 29 Oct 2024 08:01:39 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 1236119560A2;
	Tue, 29 Oct 2024 08:01:36 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:35 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 5/8] trace-cmd record: Prevent memory leak in setup_network()
Date: Tue, 29 Oct 2024 09:01:14 +0100
Message-ID: <20241029080117.625177-6-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Because of the again label, msg_handle can be already allocated if we
exit after we got a negative socket file descriptor. Free it there.
Also unassign msg_handle->fd as to not double close sfd.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-record.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3c42cdf0..7e84e897 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3904,6 +3904,7 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 
 	if (sfd < 0) {
 		free(thost);
+		tracecmd_msg_handle_close(msg_handle);
 		return NULL;
 	}
 
@@ -3934,6 +3935,7 @@ static struct tracecmd_msg_handle *setup_network(struct buffer_instance *instanc
 		if (msg_handle->version == V1_PROTOCOL) {
 			/* reconnect to the server for using the v1 protocol */
 			close(sfd);
+			msg_handle->fd = -1;
 			free(host);
 			host = NULL;
 			goto again;
-- 
2.47.0

