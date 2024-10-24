"""add unique constraint for summary

Revision ID: 24061ff82646
Revises: 1ddd1d051a99
Create Date: 2024-05-02 10:11:35.832837

"""

from alembic import op

# revision identifiers, used by Alembic.
revision = "24061ff82646"
down_revision = "1ddd1d051a99"
branch_labels = None
depends_on = None


def upgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.create_unique_constraint(
        op.f("opportunity_summary_is_forecast_uniq"),
        "opportunity_summary",
        ["is_forecast", "revision_number", "opportunity_id"],
        schema="api",
        postgresql_nulls_not_distinct=True,
    )
    # ### end Alembic commands ###


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.drop_constraint(
        op.f("opportunity_summary_is_forecast_uniq"),
        "opportunity_summary",
        schema="api",
        type_="unique",
    )
    # ### end Alembic commands ###
